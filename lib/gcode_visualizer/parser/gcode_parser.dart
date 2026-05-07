import '../models/gcode_command.dart';
import 'gcode_parse_result.dart';

class GcodeParser {
  static const _supportedCodes = {'G0', 'G00', 'G1', 'G01'};
  static final _paramPattern = RegExp(r'^([A-Za-z])(-?(?:\d+\.?\d*|\.\d+))$');

  GcodeParseResult parse(String source) {
    final commands = <GcodeCommand>[];
    final errors = <GcodeParseError>[];
    final lines = source.split('\n');

    for (var i = 0; i < lines.length; i++) {
      final lineNumber = i + 1;
      final rawLine = lines[i].trim();

      if (rawLine.isEmpty) continue;

      final result = _parseLine(rawLine, lineNumber);

      result.when(
        command: (cmd) => commands.add(cmd),
        error: (err) => errors.add(err),
        skipped: () {},
      );
    }

    return GcodeParseResult(commands: commands, errors: errors);
  }

  _LineParseResult _parseLine(String rawLine, int lineNumber) {
    var line = rawLine;

    line = _removeParenthesesComments(line);

    final comment = _extractSemicolonComment(line);
    line = comment != null
        ? line.substring(0, line.indexOf(';')).trim()
        : line.trim();

    if (line.isEmpty) {
      return _LineParseResult.skipped();
    }

    final tokens = _tokenize(line);
    if (tokens.isEmpty) {
      return _LineParseResult.skipped();
    }

    final commandCode = tokens[0].toUpperCase();

    final normalized = _normalizeCode(commandCode);
    if (!_supportedCodes.contains(normalized)) {
      return _LineParseResult.error(
        GcodeParseError(
          lineNumber: lineNumber,
          rawLine: rawLine,
          message: 'Unsupported code: $commandCode',
        ),
      );
    }

    final params = <String, double>{};
    for (var i = 1; i < tokens.length; i++) {
      final token = tokens[i];
      final match = _paramPattern.firstMatch(token);
      if (match == null) {
        return _LineParseResult.error(
          GcodeParseError(
            lineNumber: lineNumber,
            rawLine: rawLine,
            message: 'Malformed parameter: $token',
          ),
        );
      }
      final key = match.group(1)!.toUpperCase();
      final valueStr = match.group(2);
      if (valueStr == null) {
        return _LineParseResult.error(
          GcodeParseError(
            lineNumber: lineNumber,
            rawLine: rawLine,
            message: 'Missing numeric value in: $token',
          ),
        );
      }
      final value = double.tryParse(valueStr);
      if (value == null) {
        return _LineParseResult.error(
          GcodeParseError(
            lineNumber: lineNumber,
            rawLine: rawLine,
            message: 'Invalid numeric value: $token',
          ),
        );
      }
      params[key] = value;
    }

    return _LineParseResult.command(
      GcodeCommand(
        lineNumber: lineNumber,
        rawLine: rawLine,
        code: normalized,
        params: params,
        comment: comment ?? '',
      ),
    );
  }

  String _removeParenthesesComments(String line) {
    final result = StringBuffer();
    var inComment = false;
    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '(') {
        inComment = true;
      } else if (ch == ')') {
        inComment = false;
      } else if (!inComment) {
        result.write(ch);
      }
    }
    return result.toString();
  }

  String? _extractSemicolonComment(String line) {
    final index = line.indexOf(';');
    if (index == -1) return null;
    return line.substring(index + 1).trim();
  }

  List<String> _tokenize(String line) {
    final tokens = <String>[];
    final buffer = StringBuffer();
    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == ' ' || ch == '\t') {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
      } else {
        buffer.write(ch);
      }
    }
    if (buffer.isNotEmpty) {
      tokens.add(buffer.toString());
    }
    return tokens;
  }

  String _normalizeCode(String code) {
    return switch (code) {
      'G0' || 'G00' => 'G0',
      'G1' || 'G01' => 'G1',
      _ => code,
    };
  }
}

sealed class _LineParseResult {
  const _LineParseResult();

  factory _LineParseResult.command(GcodeCommand cmd) => _CommandResult(cmd);
  factory _LineParseResult.error(GcodeParseError err) => _ErrorResult(err);
  factory _LineParseResult.skipped() => const _SkippedResult();

  T when<T>({
    required T Function(GcodeCommand) command,
    required T Function(GcodeParseError) error,
    required T Function() skipped,
  }) {
    return switch (this) {
      _CommandResult(:final cmd) => command(cmd),
      _ErrorResult(:final err) => error(err),
      _SkippedResult() => skipped(),
    };
  }
}

class _CommandResult extends _LineParseResult {
  const _CommandResult(this.cmd);
  final GcodeCommand cmd;
}

class _ErrorResult extends _LineParseResult {
  const _ErrorResult(this.err);
  final GcodeParseError err;
}

class _SkippedResult extends _LineParseResult {
  const _SkippedResult();
}
