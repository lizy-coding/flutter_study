// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_ioc/model/counter_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<CounterModel>(
      create: (context) => CounterModel(name: 'Default', count: 0),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counterModel = Provider.of<CounterModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: ${counterModel.name}',
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              'Count: ${counterModel.count}',
              style: const TextStyle(fontSize: 24),
            ),
            TextField(
              onChanged: (value) {
                counterModel.setName(value);
              },
              decoration: const InputDecoration(labelText: 'Enter new name'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counterModel.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
