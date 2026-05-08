import 'package:flutter/material.dart';

import '../models/toolpath_segment.dart';
import '../parser/gcode_parse_result.dart';
import '../parser/gcode_parser.dart';
import '../services/toolpath_builder.dart';

const _kDefaultSample = '''
; Flutter G-code visualizer sample
G0 X0 Y0
G1 X80 Y0 F1200
G1 X80 Y50
G1 X20 Y50
G1 X20 Y20
G1 X60 Y20
G0 X0 Y0
''';

class GcodePlayerController extends ChangeNotifier {
  GcodePlayerController({
    required TickerProvider vsync,
  }) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 5),
    )
      ..addListener(_onAnimationTick)
      ..addStatusListener(_onAnimationStatusChanged);
  }

  late final AnimationController _animationController;
  final _parser = GcodeParser();

  String _source = _kDefaultSample.trim();
  GcodeParseResult? _parseResult;
  List<ToolpathSegment> _segments = [];
  int _currentCommandIndex = -1;
  bool _isPlaying = false;
  double _progress = 0;
  double _speedMultiplier = 1.0;
  final List<String> _logs = [];

  String get source => _source;
  GcodeParseResult? get parseResult => _parseResult;
  List<ToolpathSegment> get segments => _segments;
  int get currentCommandIndex => _currentCommandIndex;
  bool get isPlaying => _isPlaying;
  double get progress => _progress;
  double get speedMultiplier => _speedMultiplier;
  List<String> get logs => List.unmodifiable(_logs);

  int get totalCommands => _parseResult?.commands.length ?? 0;
  int get errorCount => _parseResult?.errors.length ?? 0;

  void updateSource(String value) {
    _source = value;
    notifyListeners();
  }

  void parse() {
    final result = _parser.parse(_source);
    _parseResult = result;
    _segments = result.hasErrors
        ? ToolpathBuilder.build(
            result.commands,
          )
        : ToolpathBuilder.build(result.commands);
    _currentCommandIndex = -1;
    _progress = 0;
    _isPlaying = false;
    _animationController.stop();
    _animationController.value = 0;
    _addLog('解析完成: ${result.commands.length} 条指令, ${result.errors.length} 个错误');
    notifyListeners();
  }

  void play() {
    if (_segments.isEmpty) return;
    if (_progress >= 1.0) {
      _progress = 0;
      _animationController.value = 0;
    }
    _isPlaying = true;
    _animationController.duration = Duration(
      milliseconds: (5000 / _speedMultiplier).round(),
    );
    _animationController.forward(from: _progress);
    _addLog('开始播放');
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    _animationController.stop();
    _addLog('暂停播放 (进度: ${(_progress * 100).toStringAsFixed(1)}%)');
    notifyListeners();
  }

  void reset() {
    _isPlaying = false;
    _progress = 0;
    _currentCommandIndex = -1;
    _animationController.stop();
    _animationController.value = 0;
    _addLog('重置');
    notifyListeners();
  }

  void setSpeed(double value) {
    _speedMultiplier = value;
    if (_isPlaying) {
      _animationController.stop();
      play();
    }
    notifyListeners();
  }

  void seek(double value) {
    _progress = value.clamp(0.0, 1.0);
    _animationController.value = _progress;
    _updateCurrentCommandIndex();
    notifyListeners();
  }

  void loadSample() {
    _source = _kDefaultSample.trim();
    _addLog('加载示例 G-code');
    notifyListeners();
  }

  void _onAnimationTick() {
    _progress = _animationController.value;
    _updateCurrentCommandIndex();
    notifyListeners();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    _isPlaying = false;
    _progress = 1.0;
    _updateCurrentCommandIndex();
    _addLog('播放完成');
    notifyListeners();
  }

  void _updateCurrentCommandIndex() {
    if (_segments.isEmpty) {
      _currentCommandIndex = -1;
      return;
    }
    final totalSegments = _segments.length;
    final idx = (_progress * totalSegments).floor().clamp(0, totalSegments - 1);
    final cmd = _segments[idx].command;
    final cmdIdx = _parseResult?.commands.indexWhere(
          (c) => c.lineNumber == cmd.lineNumber,
        ) ??
        -1;
    _currentCommandIndex = cmdIdx;
  }

  void _addLog(String message) {
    _logs.add(
        '[${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}] $message');
    if (_logs.length > 50) {
      _logs.removeAt(0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
