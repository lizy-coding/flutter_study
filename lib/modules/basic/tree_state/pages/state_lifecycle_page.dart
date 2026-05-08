import 'package:flutter/material.dart';

/// 侧重打印 StatefulWidget 生命周期，配合 push/pop、setState 观察回调顺序。
class StateLifecyclePage extends StatefulWidget {
  const StateLifecyclePage({super.key});

  @override
  State<StateLifecyclePage> createState() => _StateLifecyclePageState();
}

class _StateLifecyclePageState extends State<StateLifecyclePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('[StateLifecyclePage] initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('[StateLifecyclePage] didChangeDependencies');
  }

  @override
  void didUpdateWidget(covariant StateLifecyclePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('[StateLifecyclePage] didUpdateWidget');
  }

  @override
  void deactivate() {
    debugPrint('[StateLifecyclePage] deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('[StateLifecyclePage] dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[StateLifecyclePage] build counter=$_counter');
    return Scaffold(
      appBar: AppBar(title: const Text('State Lifecycle Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('StatefulWidget 生命周期 + setState 行为'),
            const SizedBox(height: 16),
            Text('Counter: $_counter'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _counter++;
                    });
                    debugPrint('[StateLifecyclePage] setState -> $_counter');
                  },
                  child: const Text('setState +1'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    debugPrint('[StateLifecyclePage] push sample page');
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LifecycleChildPage(),
                      ),
                    );
                    debugPrint('[StateLifecyclePage] pop sample page');
                  },
                  child: const Text('Push & Pop 页面'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LifecycleChildPage extends StatelessWidget {
  const LifecycleChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('[LifecycleChildPage] build');
    return Scaffold(
      appBar: AppBar(title: const Text('Child Page')),
      body: const Center(
        child: Text('观察父页面 push/pop 时的生命周期日志'),
      ),
    );
  }
}
