import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/models/event_log.dart';
import '../../core/widgets/event_log_view.dart';
import '../../core/widgets/code_snippet_view.dart';

class MicrotaskQueuePage extends StatefulWidget {
  const MicrotaskQueuePage({Key? key}) : super(key: key);

  @override
  State<MicrotaskQueuePage> createState() => _MicrotaskQueuePageState();
}

class _MicrotaskQueuePageState extends State<MicrotaskQueuePage> {
  final List<EventLog> _logs = [];
  bool _isRunning = false;
  final ScrollController _scrollController = ScrollController();
  bool _showTimestamps = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _addLog(String message, EventType type) {
    if (!_isRunning) return;
    
    setState(() {
      _logs.add(EventLog(
        message: message,
        type: type,
        id: _logs.length + 1,
      ));
    });
    
    // 使用微任务来确保在当前帧渲染后滚动到底部
    scheduleMicrotask(_scrollToBottom);
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  void _runBasicMicrotaskTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始微任务队列测试', EventType.info);
    _addLog('代码开始执行', EventType.sync);
    
    // 添加事件任务
    Future(() {
      _addLog('事件任务执行', EventType.event);
    });
    
    // 使用scheduleMicrotask添加微任务
    scheduleMicrotask(() {
      _addLog('scheduleMicrotask 微任务1执行', EventType.microtask);
    });
    
    // 使用Future.microtask添加微任务
    Future.microtask(() {
      _addLog('Future.microtask 微任务2执行', EventType.microtask);
    });
    
    // 再添加一个事件任务
    Future(() {
      _addLog('另一个事件任务执行', EventType.event);
    });
    
    // 再添加一个微任务
    scheduleMicrotask(() {
      _addLog('scheduleMicrotask 微任务3执行', EventType.microtask);
    });
    
    _addLog('代码结束执行', EventType.sync);
    
    // 给测试一个结束标记
    Future.delayed(const Duration(seconds: 2), () {
      _addLog('微任务队列测试结束', EventType.info);
      _isRunning = false;
    });
  }

  void _runThenMicrotaskTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始Future.then微任务测试', EventType.info);
    _addLog('代码开始执行', EventType.sync);
    
    // Future.then 会将回调注册为微任务
    Future(() {
      _addLog('Future事件任务执行', EventType.event);
    }).then((_) {
      _addLog('Future.then微任务1执行', EventType.microtask);
    }).then((_) {
      _addLog('Future.then微任务2执行', EventType.microtask);
    });
    
    // 另外添加一个事件任务和微任务，观察执行顺序
    Future(() {
      _addLog('另一个事件任务执行', EventType.event);
    });
    
    scheduleMicrotask(() {
      _addLog('scheduleMicrotask 微任务执行', EventType.microtask);
    });
    
    _addLog('代码结束执行', EventType.sync);
    
    // 给测试一个结束标记
    Future.delayed(const Duration(seconds: 2), () {
      _addLog('Future.then微任务测试结束', EventType.info);
      _isRunning = false;
    });
  }

  void _runNestedMicrotaskTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始嵌套微任务测试', EventType.info);
    _addLog('代码开始执行', EventType.sync);
    
    // 外层微任务中嵌套其他微任务
    scheduleMicrotask(() {
      _addLog('外层微任务1执行', EventType.microtask);
      
      // 在微任务中添加新的微任务
      scheduleMicrotask(() {
        _addLog('嵌套微任务1执行', EventType.microtask);
      });
      
      // 添加另一个嵌套微任务
      scheduleMicrotask(() {
        _addLog('嵌套微任务2执行', EventType.microtask);
        
        // 再嵌套一层微任务
        scheduleMicrotask(() {
          _addLog('二层嵌套微任务执行', EventType.microtask);
        });
      });
      
      _addLog('外层微任务1继续执行', EventType.microtask);
    });
    
    // 添加另一个外层微任务
    scheduleMicrotask(() {
      _addLog('外层微任务2执行', EventType.microtask);
    });
    
    // 添加一个事件任务
    Future(() {
      _addLog('事件任务执行', EventType.event);
    });
    
    _addLog('代码结束执行', EventType.sync);
    
    // 给测试一个结束标记
    Future.delayed(const Duration(seconds: 2), () {
      _addLog('嵌套微任务测试结束', EventType.info);
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('微任务队列演示'),
        actions: [
          IconButton(
            icon: Icon(_showTimestamps ? Icons.timer : Icons.timer_off),
            onPressed: () {
              setState(() {
                _showTimestamps = !_showTimestamps;
              });
            },
            tooltip: _showTimestamps ? '隐藏时间戳' : '显示时间戳',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearLogs,
            tooltip: '清除日志',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '微任务队列介绍',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '微任务队列(Microtask Queue)用于处理高优先级的异步任务。微任务总是在事件任务之前执行，且会阻塞事件循环直到微任务队列清空。',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _runBasicMicrotaskTest,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('基础微任务测试'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _runThenMicrotaskTest,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Future.then测试'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _runNestedMicrotaskTest,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('嵌套微任务测试'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '代码示例',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            CodeSnippetView(
              title: 'Microtask Queue 示例代码',
              code: '''
// 使用scheduleMicrotask添加微任务
scheduleMicrotask(() {
  print('微任务执行');
});

// 使用Future.microtask添加微任务
Future.microtask(() {
  print('另一个微任务执行');
});

// Future完成后的then回调也是微任务
Future(() {
  print('事件任务执行');
}).then((_) {
  print('then回调作为微任务执行');
});
''',
            ),
            const SizedBox(height: 16),
            const Text(
              '执行日志',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: EventLogView(
                logs: _logs,
                showTimestamp: _showTimestamps,
                scrollController: _scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}