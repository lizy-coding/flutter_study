import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '多任务 Isolate Stream Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MultiTaskIsolatePage(title: '多任务并行处理与实时进度监听'),
    );
  }
}

// 任务模型
class Task {
  final int id;
  final String name;
  int progress;
  bool isCompleted;
  Isolate? isolate;
  ReceivePort? receivePort;
  StreamSubscription<dynamic>? subscription;
  final Color color;

  Task({
    required this.id,
    required this.name,
    this.progress = 0,
    this.isCompleted = false,
  }) : color = _getRandomColor();

  static Color _getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(200) + 55, // 确保颜色不太暗
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
      1.0,
    );
  }

  void dispose() {
    isolate?.kill(priority: Isolate.immediate);
    subscription?.cancel();
    receivePort?.close();
  }
}

class MultiTaskIsolatePage extends StatefulWidget {
  const MultiTaskIsolatePage({super.key, required this.title});

  final String title;

  @override
  State<MultiTaskIsolatePage> createState() => _MultiTaskIsolatePageState();
}

class _MultiTaskIsolatePageState extends State<MultiTaskIsolatePage> {
  final List<Task> _tasks = [];
  int _nextTaskId = 1;

  @override
  void dispose() {
    // 清理所有任务资源
    for (final task in _tasks) {
      task.dispose();
    }
    super.dispose();
  }

  // 创建并启动新任务
  void _startNewTask() {
    final task = Task(
      id: _nextTaskId++,
      name: '任务 ${_nextTaskId - 1}',
    );

    setState(() {
      _tasks.add(task);
    });

    _startTaskInIsolate(task);
  }

  // 在Isolate中启动任务
  void _startTaskInIsolate(Task task) async {
    task.receivePort = ReceivePort();

    // 启动Isolate，传递任务ID和sendPort
    task.isolate = await Isolate.spawn(
      _taskIsolate,
      {
        'sendPort': task.receivePort!.sendPort,
        'taskId': task.id,
      },
    );

    // 监听任务进度更新
    task.subscription = task.receivePort!.listen((dynamic data) {
      if (data is Map<String, dynamic>) {
        final int taskId = data['taskId'];
        final Task? updatedTask = _tasks.firstWhereOrNull((t) => t.id == taskId);

        if (updatedTask != null) {
          setState(() {
            if (data.containsKey('progress')) {
              updatedTask.progress = data['progress'];
            }
            if (data.containsKey('completed')) {
              updatedTask.isCompleted = data['completed'];
            }
          });
        }
      }
    });
  }

  // 停止特定任务
  void _stopTask(Task task) {
    setState(() {
      task.dispose();
      _tasks.remove(task);
    });
  }

  // 停止所有任务
  void _stopAllTasks() {
    setState(() {
      for (final task in _tasks) {
        task.dispose();
      }
      _tasks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          if (_tasks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _stopAllTasks,
              tooltip: '停止所有任务',
            ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text('点击下方按钮添加任务'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              task.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => _stopTask(task),
                              tooltip: '停止任务',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: task.progress / 100,
                          backgroundColor: Colors.grey[200],
                          color: task.color,
                          minHeight: 12,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '进度: ${task.progress}%',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              task.isCompleted
                                  ? '已完成'
                                  : '进行中',
                              style: TextStyle(
                                color: task.isCompleted
                                    ? Colors.green
                                    : Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewTask,
        tooltip: '添加新任务',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Isolate中执行的任务函数
void _taskIsolate(dynamic message) {
  final SendPort sendPort = message['sendPort'];
  final int taskId = message['taskId'];
  final Random random = Random();
  int progress = 0;
  
  // 每个任务的完成时间随机（10-30秒）
  final int totalSteps = random.nextInt(20) + 10;
  final int delayMs = random.nextInt(500) + 300;
  
  // 创建定时器模拟任务执行
  Timer.periodic(Duration(milliseconds: delayMs), (timer) {
    // 每次进度随机增加（2-8%）
    final int progressIncrement = random.nextInt(7) + 2;
    progress = min(progress + progressIncrement, 100);
    
    // 发送进度更新
    sendPort.send({
      'taskId': taskId,
      'progress': progress,
      'completed': progress >= 100,
    });
    
    // 任务完成时停止定时器
    if (progress >= 100 || timer.tick >= totalSteps) {
      sendPort.send({
        'taskId': taskId,
        'progress': 100,
        'completed': true,
      });
      timer.cancel();
    }
  });
}
