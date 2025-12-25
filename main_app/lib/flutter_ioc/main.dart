// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ioc/ioc.dart' as ioc;
import 'model/counter_model.dart';

void main() {
  // Set up the IoC container and register dependencies once at startup.
  final container = ioc.Container(environment: {'appName': 'Counter'});
  container.registerSingleton<CounterModel>(
    (_) => CounterModel(name: 'Default', count: 0),
  );

  runApp(
    Provider<ioc.IoCContainer>.value(
      value: container,
      child: ChangeNotifierProvider<CounterModel>(
        create: (_) => container.resolve<CounterModel>(),
        child: const MyApp(),
      ),
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
