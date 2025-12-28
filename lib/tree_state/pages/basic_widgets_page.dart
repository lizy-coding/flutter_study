import 'package:flutter/material.dart';

/// 展示 StatelessWidget 与 StatefulWidget 重建行为差异，便于讲解 Widget/Element 关系。
class BasicWidgetsPage extends StatefulWidget {
  const BasicWidgetsPage({super.key});

  @override
  State<BasicWidgetsPage> createState() => _BasicWidgetsPageState();
}

class _BasicWidgetsPageState extends State<BasicWidgetsPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint('[BasicWidgetsPage] build counter=$_counter');
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Widgets Demo')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;
          });
        },
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stateless vs Stateful：Widget 是配置对象，Element 才与 RenderObject/State 关联。',
            ),
            const SizedBox(height: 16),
            Text('Parent rebuild count: $_counter'),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Flex(
                    direction: constraints.maxWidth > 480
                        ? Axis.horizontal
                        : Axis.vertical,
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: StatelessBox(count: _counter),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16, height: 16),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: StatefulBox(count: _counter),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatelessBox extends StatelessWidget {
  final int count;

  const StatelessBox({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    debugPrint('[StatelessBox] build count=$count');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('StatelessWidget'),
        Text('count: $count'),
      ],
    );
  }
}

class StatefulBox extends StatefulWidget {
  final int count;

  const StatefulBox({super.key, required this.count});

  @override
  State<StatefulBox> createState() => _StatefulBoxState();
}

class _StatefulBoxState extends State<StatefulBox> {
  @override
  void initState() {
    super.initState();
    debugPrint('[StatefulBox] initState');
  }

  @override
  void dispose() {
    debugPrint('[StatefulBox] dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[StatefulBox] build count=${widget.count}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('StatefulWidget'),
        Text('count: ${widget.count}'),
      ],
    );
  }
}
