import 'package:flutter/material.dart';

import 'task_manager.dart';

class MultiTaskIsolatePage extends StatefulWidget {
  const MultiTaskIsolatePage({super.key, required this.title});

  final String title;

  @override
  State<MultiTaskIsolatePage> createState() => _MultiTaskIsolatePageState();
}

class _MultiTaskIsolatePageState extends State<MultiTaskIsolatePage> {
  late final TaskManager _taskManager;

  @override
  void initState() {
    super.initState();
    _taskManager = TaskManager(
      onTaskUpdate: (task) {
        setState(() {});
      },
      onTaskComplete: (task) {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _taskManager.dispose();
    super.dispose();
  }

  void _startNewTask() {
    _taskManager.startNewTask();
    setState(() {});
  }

  void _pauseTask(Task task) {
    _taskManager.pauseTask(task);
    setState(() {});
  }

  void _resumeTask(Task task) {
    _taskManager.resumeTask(task);
    setState(() {});
  }

  void _stopTask(Task task) {
    _taskManager.stopTask(task);
    setState(() {});
  }

  void _stopAllTasks() {
    _taskManager.stopAllTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          if (_taskManager.tasks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _stopAllTasks,
              tooltip: '停止所有任务',
            ),
        ],
      ),
      body: _taskManager.tasks.isEmpty
          ? const Center(
              child: Text('点击下方按钮添加任务'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _taskManager.tasks.length,
              itemBuilder: (context, index) {
                final task = _taskManager.tasks[index];
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
                                  : task.isPaused
                                      ? '已暂停'
                                      : '进行中',
                              style: TextStyle(
                                color: task.isCompleted
                                    ? Colors.green
                                    : task.isPaused
                                        ? Colors.orange
                                        : Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (!task.isCompleted)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(task.isPaused ? Icons.play_arrow : Icons.pause),
                                onPressed: task.isPaused
                                    ? () => _resumeTask(task)
                                    : () => _pauseTask(task),
                                tooltip: task.isPaused ? '继续任务' : '暂停任务',
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
