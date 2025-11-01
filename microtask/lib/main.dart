import 'package:flutter/material.dart';
import 'features/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 事件机制学习',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
<<<<<<< HEAD
}

/// Flutter事件机制示例页面
/// 演示微任务队列和事件队列的执行顺序和特性
class EventDemoPage extends StatefulWidget {
  const EventDemoPage({super.key, required this.title});

  final String title;

  @override
  State<EventDemoPage> createState() => _EventDemoPageState();
}

class _EventDemoPageState extends State<EventDemoPage> {
  // 用于记录事件执行日志
  final List<String> _logs = [];
  // 控制是否正在执行测试
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _runBasicEventTest,
                  child: const Text('基础事件测试'),
                ),
                ElevatedButton(
                  onPressed: _runNestedEventTest,
                  child: const Text('嵌套事件测试'),
                ),
                ElevatedButton(
                  onPressed: _runFutureTest,
                  child: const Text('Future测试'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  Color color;
                  
                  // 为不同类型的日志设置不同颜色
                  if (log.contains('同步')) {
                    color = Colors.black;
                  } else if (log.contains('微任务')) {
                    color = Colors.blue;
                  } else if (log.contains('事件任务')) {
                    color = Colors.red;
                  } else {
                    color = Colors.grey;
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      log,
                      style: TextStyle(color: color),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearLogs,
        tooltip: '清除日志',
        child: const Icon(Icons.delete),
      ),
    );
  }

  /// 清除所有日志
  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  /// 添加日志
  void _addLog(String message) {
    if (_isRunning) {
      setState(() {
        _logs.add('${_logs.length + 1}. $message');
      });
    }
  }

  /// 基础事件测试：展示同步代码、微任务和事件任务的执行顺序
  void _runBasicEventTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始基础事件测试');
    _addLog('【同步】代码开始执行');
    
    // 使用Future()添加到事件队列
    Future(() {
      _addLog('【事件任务】Future() 执行');
    });
    
    // 使用Future.delayed添加到事件队列，延迟1秒
    Future.delayed(const Duration(seconds: 1), () {
      _addLog('【事件任务】Future.delayed 1秒后执行');
    });
    
    // 使用scheduleMicrotask添加到微任务队列
    scheduleMicrotask(() {
      _addLog('【微任务】scheduleMicrotask 执行');
    });
    
    // 使用Future.microtask添加到微任务队列
    Future.microtask(() {
      _addLog('【微任务】Future.microtask 执行');
    });
    
    // 使用Timer.run添加到事件队列
    Timer.run(() {
      _addLog('【事件任务】Timer.run 执行');
    });
    
    _addLog('【同步】代码结束执行');
    
    // 给测试一个结束标记（不影响运行效果的同时保持清晰）
    Future.delayed(const Duration(seconds: 2), () {
      _addLog('基础事件测试结束');
      _isRunning = false;
    });
  }

  /// 嵌套事件测试：展示在事件和微任务中再次调度其他事件和微任务的执行顺序
  void _runNestedEventTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始嵌套事件测试');
    _addLog('【同步】代码开始执行');
    
    // 在事件任务中嵌套微任务和事件任务
    Future(() {
      _addLog('【事件任务 A】外层 Future 执行');
      
      // 在事件A中嵌套一个微任务
      scheduleMicrotask(() {
        _addLog('【微任务】事件A中的微任务执行');
      });
      
      // 在事件A中嵌套一个事件任务
      Future(() {
        _addLog('【事件任务】事件A中的事件任务执行');
      });
    });
    
    // 在微任务中嵌套微任务和事件任务
    scheduleMicrotask(() {
      _addLog('【微任务 A】外层微任务执行');
      
      // 在微任务A中嵌套一个微任务
      scheduleMicrotask(() {
        _addLog('【微任务】微任务A中的微任务执行');
      });
      
      // 在微任务A中嵌套一个事件任务
      Future(() {
        _addLog('【事件任务】微任务A中的事件任务执行');
      });
    });
    
    // 另一个独立的事件任务
    Future(() {
      _addLog('【事件任务 B】外层 Future 执行');
    });
    
    _addLog('【同步】代码结束执行');
    
    // 给测试一个结束标记
    Future.delayed(const Duration(seconds: 2), () {
      _addLog('嵌套事件测试结束');
      _isRunning = false;
    });
  }

  /// Future测试：展示Future链式调用、async/await的执行顺序
  void _runFutureTest() async {
    if (_isRunning) return;
    _isRunning = true;
    _clearLogs();
    
    _addLog('开始Future测试');
    _addLog('【同步】代码开始执行');
    
    // Future的链式调用
    Future(() => _addLog('【事件任务】Future链 - 初始任务'))
        .then((_) => _addLog('【微任务】Future链 - then 1'))
        .then((_) {
          _addLog('【微任务】Future链 - then 2');
          return Future(() => _addLog('【事件任务】Future链 - 内部Future'));
        })
        .then((_) => _addLog('【微任务】Future链 - then 3'));
    
    // 使用async/await
    _addLog('【同步】即将调用async函数');
    _executeAsyncFunction();
    _addLog('【同步】async函数调用之后');
    
    _addLog('【同步】代码结束执行');
    
    // 给测试一个结束标记
    Future.delayed(const Duration(seconds: 3), () {
      _addLog('Future测试结束');
      _isRunning = false;
    });
  }

  /// 辅助函数：演示async/await的执行顺序
  Future<void> _executeAsyncFunction() async {
    _addLog('【同步】async函数开始');
    
    // await之前的代码是同步执行的
    _addLog('【同步】await之前的代码');
    
    // await会暂停当前函数，并将await之后的代码作为微任务
    await Future(() {
      _addLog('【事件任务】await的Future执行');
    });
    
    // await之后的代码会被包装成微任务
    _addLog('【微任务】await之后的代码');
    
    // 再次await
    await Future.delayed(const Duration(milliseconds: 500), () {
      _addLog('【事件任务】第二个await的Future执行');
    });
     
    // 第二个await之后的代码也会被包装成微任务
    _addLog('【微任务】第二个await之后的代码');
    
    _addLog('【微任务】async函数结束');
  }
}
=======
}
>>>>>>> 54a9a9a50b1bd7fb3c068ef70582392351489284
