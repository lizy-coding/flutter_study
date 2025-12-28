import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/models/event_log.dart';
import '../../core/widgets/event_log_view.dart';
import '../../core/widgets/code_snippet_view.dart';

class AdvancedExamplesPage extends StatefulWidget {
  const AdvancedExamplesPage({Key? key}) : super(key: key);

  @override
  State<AdvancedExamplesPage> createState() => _AdvancedExamplesPageState();
}

class _AdvancedExamplesPageState extends State<AdvancedExamplesPage> with SingleTickerProviderStateMixin {
  final List<EventLog> _logs = [];
  bool _isRunning = false;
  final ScrollController _scrollController = ScrollController();
  bool _showTimestamps = true;
  late TabController _tabController;
  
  final Map<String, String> _codeExamples = {
    'async/await': r'''
Future<void> example() async {
  print('函数开始');
  
  // await之前的代码是同步执行的
  print('await之前的代码');
  
  // await会暂停函数，并将await之后的代码包装成微任务
  await Future(() {
    print('await的Future执行');
  });
  
  // 这部分代码会被包装成微任务
  print('await之后的代码');
  
  await Future.delayed(Duration(milliseconds: 500));
  
  // 第二个await之后的代码也会被包装成微任务
  print('第二个await之后的代码');
}''',
    'Future.value': r'''
// Future.value会立即完成并将then回调添加到微任务队列
Future.value('immediate value').then((value) {
  print('Future.value微任务: $value');
});

// 对比普通Future
Future(() {
  return 'computed value';
}).then((value) {
  print('普通Future: $value');
});''',
    'Future链式调用': r'''
Future(() => print('初始Future'))
    .then((_) => print('第一个then微任务'))
    .then((_) {
      print('第二个then微任务');
      return Future(() => print('嵌套事件任务'));
    })
    .then((_) => print('第三个then微任务'));''',
    'Zone': r'''
import 'dart:async';

// Zone可以拦截和修改异步操作
runZoned(() {
  Future(() => print('在自定义Zone中执行的Future'));
  scheduleMicrotask(() => print('在自定义Zone中执行的微任务'));
}, zoneSpecification: ZoneSpecification(
  scheduleMicrotask: (Zone self, ZoneDelegate parent, Zone zone, void Function() f) {
    print('微任务被调度');
    parent.scheduleMicrotask(zone, f);
  },
  createTimer: (Zone self, ZoneDelegate parent, Zone zone, 
                Duration duration, void Function() f) {
    print('计时器被创建，持续时间: $duration');
    return parent.createTimer(zone, duration, f);
  },
));''',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
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

  void _runAsyncAwaitTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始async/await测试', EventType.info);
    _addLog('代码开始执行', EventType.sync);
    
    _addLog('即将调用async函数', EventType.sync);
    await _executeAsyncFunction();
    _addLog('async函数调用完成', EventType.sync);
    
    _addLog('代码结束执行', EventType.sync);
    
    // 给测试一个结束标记
    Future.delayed(const Duration(seconds: 2), () {
      _addLog('async/await测试结束', EventType.info);
      _isRunning = false;
    });
  }

  Future<void> _executeAsyncFunction() async {
    _addLog('async函数开始', EventType.sync);
    
    // await之前的代码是同步执行的
    _addLog('await之前的代码', EventType.sync);
    
    // await会暂停当前函数，并将await之后的代码作为微任务
    await Future(() {
      _addLog('await的Future执行', EventType.event);
    });
    
    // await之后的代码会被包装成微任务
    _addLog('await之后的代码', EventType.microtask);
    
    // 再次await
    await Future.delayed(const Duration(milliseconds: 500), () {
      _addLog('第二个await的Future执行（延迟500ms）', EventType.event);
    });
    
    // 第二个await之后的代码也会被包装成微任务
    _addLog('第二个await之后的代码', EventType.microtask);
    
    _addLog('async函数结束', EventType.microtask);
  }

  void _runFutureValueTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始Future.value测试', EventType.info);
    _addLog('代码开始执行', EventType.sync);
    
    // 使用Future.value
    Future.value('立即值').then((value) {
      _addLog('Future.value微任务: $value', EventType.microtask);
    });
    
    // 对比普通Future
    Future(() {
      _addLog('普通Future事件任务执行', EventType.event);
      return '计算值';
    }).then((value) {
      _addLog('普通Future的then回调: $value', EventType.microtask);
    });
    
    // 添加一些额外的微任务和事件任务
    scheduleMicrotask(() {
      _addLog('独立的微任务', EventType.microtask);
    });
    
    Future(() {
      _addLog('独立的事件任务', EventType.event);
    });
    
    _addLog('代码结束执行', EventType.sync);
    
    // 给测试一个结束标记
    Future.delayed(const Duration(seconds: 2), () {
      _addLog('Future.value测试结束', EventType.info);
      _isRunning = false;
    });
  }

  void _runFutureChainTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始Future链式调用测试', EventType.info);
    _addLog('代码开始执行', EventType.sync);
    
    Future(() {
      _addLog('初始Future', EventType.event);
    }).then((_) {
      _addLog('第一个then微任务', EventType.microtask);
    }).then((_) {
      _addLog('第二个then微任务', EventType.microtask);
      
      // 在then回调中返回一个新的Future
      return Future(() {
        _addLog('嵌套事件任务', EventType.event);
      });
    }).then((_) {
      _addLog('第三个then微任务', EventType.microtask);
    });
    
    // 添加一些额外的任务来对比执行顺序
    scheduleMicrotask(() {
      _addLog('独立的微任务', EventType.microtask);
    });
    
    Future(() {
      _addLog('独立的事件任务', EventType.event);
    });
    
    _addLog('代码结束执行', EventType.sync);
    
    // 给测试一个结束标记
    Future.delayed(const Duration(seconds: 2), () {
      _addLog('Future链式调用测试结束', EventType.info);
      _isRunning = false;
    });
  }

  void _runZoneTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始Zone测试', EventType.info);
    _addLog('代码开始执行', EventType.sync);
    
    // 创建一个自定义Zone来拦截异步操作
    runZoned(() {
      _addLog('进入自定义Zone', EventType.sync);
      
      Future(() {
        _addLog('在自定义Zone中执行的Future', EventType.event);
      });
      
      scheduleMicrotask(() {
        _addLog('在自定义Zone中执行的微任务', EventType.microtask);
      });
      
      _addLog('离开自定义Zone', EventType.sync);
    }, zoneSpecification: ZoneSpecification(
      scheduleMicrotask: (Zone self, ZoneDelegate parent, Zone zone, void Function() f) {
        _addLog('微任务被调度', EventType.info);
        parent.scheduleMicrotask(zone, f);
      },
      createTimer: (Zone self, ZoneDelegate parent, Zone zone, 
                  Duration duration, void Function() f) {
        _addLog('计时器被创建，持续时间: $duration', EventType.info);
        return parent.createTimer(zone, duration, f);
      },
    ));
    
    // 在主Zone中添加一些任务
    Future(() {
      _addLog('在主Zone中执行的Future', EventType.event);
    });
    
    scheduleMicrotask(() {
      _addLog('在主Zone中执行的微任务', EventType.microtask);
    });
    
    _addLog('代码结束执行', EventType.sync);
    
    // 给测试一个结束标记
    Future.delayed(const Duration(seconds: 2), () {
      _addLog('Zone测试结束', EventType.info);
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('高级事件机制演示'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'async/await'),
            Tab(text: 'Future.value'),
            Tab(text: 'Future链'),
            Tab(text: 'Zone'),
          ],
        ),
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
          children: [
            SizedBox(
              height: 200,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent(
                    'async/await',
                    'async/await语法是Future的语法糖，使异步代码看起来像同步代码。'
                    'await会暂停函数执行，并将await之后的代码包装成微任务。',
                    _runAsyncAwaitTest,
                  ),
                  _buildTabContent(
                    'Future.value',
                    'Future.value会立即完成一个Future，不会将回调添加到事件队列，'
                    '而是直接将then回调添加到微任务队列。',
                    _runFutureValueTest,
                  ),
                  _buildTabContent(
                    'Future链式调用',
                    'Future的then方法返回一个新的Future，可以形成链式调用。'
                    '每个then回调都会被添加到微任务队列，而不是事件队列。',
                    _runFutureChainTest,
                  ),
                  _buildTabContent(
                    'Zone',
                    'Zone允许拦截和修改异步操作，如调度微任务和创建计时器。'
                    '可用于错误处理、性能追踪和测试。',
                    _runZoneTest,
                  ),
                ],
              ),
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

  Widget _buildTabContent(String title, String description, VoidCallback onRun) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRun,
            icon: const Icon(Icons.play_arrow),
            label: Text('运行$title测试'),
          ),
          const SizedBox(height: 8),
          CodeSnippetView(
            title: '$title 示例代码',
            code: _codeExamples[title] ?? '',
          ),
        ],
      ),
    );
  }
}
