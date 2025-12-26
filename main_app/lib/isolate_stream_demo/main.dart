import 'package:flutter/material.dart';

import 'module_root.dart';

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
