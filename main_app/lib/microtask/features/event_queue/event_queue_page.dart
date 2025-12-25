import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/models/event_log.dart';
import '../../core/widgets/event_log_view.dart';
import '../../core/widgets/code_snippet_view.dart';

class EventQueuePage extends StatefulWidget {
  const EventQueuePage({Key? key}) : super(key: key);

  @override
  State<EventQueuePage> createState() => _EventQueuePageState();
}

class _EventQueuePageState extends State<EventQueuePage> {
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

  void _runBasicEventTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始事件队列测试', EventType.info);
    _addLog('代码开始执行', EventType.sync);
    
    // 使用Future()添加到事件队列
    Future(() {
      _addLog('Future() 执行', EventType.event);
    });
    
    // 使用Future.delayed添加到事件队列，延迟0.5秒
    Future.delayed(const Duration(milliseconds: 500), () {
      _addLog('Future.delayed 0.5秒后执行', EventType.event);
    });
    
    // 使用Future.delayed添加到事件队列，延迟1秒
    Future.delayed(const Duration(seconds: 1), () {
      _addLog('Future.delayed 1秒后执行', EventType.event);
    });
    
    // 使用Future.delayed添加到事件队列，延迟2秒
    Future.delayed(const Duration(seconds: 2), () {
      _addLog('Future.delayed 2秒后执行', EventType.event);
    });
    
    // 使用Timer.run添加到事件队列
    Timer.run(() {
      _addLog('Timer.run 执行', EventType.event);
    });
    
    _addLog('代码结束执行', EventType.sync);
    
    // 给测试一个结束标记
    Future.delayed(const Duration(seconds: 3), () {
      _addLog('事件队列测试结束', EventType.info);
      _isRunning = false;
    });
  }

  void _runIoEventTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始IO事件测试', EventType.info);
    _addLog('代码开始执行', EventType.sync);
    
    // 模拟网络请求或IO操作
    Future(() {
      _addLog('模拟IO操作开始', EventType.event);
      
      // 模拟IO操作处理时间
      return Future.delayed(const Duration(seconds: 1), () {
        return '数据加载完成';
      });
    }).then((result) {
      _addLog('IO操作结果: $result', EventType.event);
    });
    
    // 模拟多个并发IO操作
    Future.wait([
      Future.delayed(const Duration(milliseconds: 800), () {
        _addLog('并发IO操作1完成', EventType.event);
        return 'Result 1';
      }),
      Future.delayed(const Duration(milliseconds: 1200), () {
        _addLog('并发IO操作2完成', EventType.event);
        return 'Result 2';
      }),
    ]).then((results) {
      _addLog('所有并发操作完成: $results', EventType.event);
    });
    
    _addLog('代码结束执行', EventType.sync);
    
    // 给测试一个结束标记
    Future.delayed(const Duration(seconds: 3), () {
      _addLog('IO事件测试结束', EventType.info);
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('事件队列演示'),
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
              '事件队列介绍',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '事件队列是 Flutter 事件循环的一部分，用于处理异步操作如 I/O、计时器等。事件队列中的任务会在微任务队列清空后执行。',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _runBasicEventTest,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('基础事件队列测试'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _runIoEventTest,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('IO事件测试'),
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
              title: 'Event Queue 示例代码',
              code: '''
// 使用Future()添加到事件队列
Future(() {
  print('事件队列任务执行');
});

// 使用Future.delayed添加到事件队列并延迟执行
Future.delayed(Duration(seconds: 1), () {
  print('延迟1秒后执行的事件队列任务');
});

// 使用Timer.run添加到事件队列
Timer.run(() {
  print('Timer事件队列任务执行');
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