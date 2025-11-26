import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tree & Lifecycle Demo',
      debugShowCheckedModeBanner: false,
      home: const DemoHomePage(),
      routes: {
        '/basic_widgets': (context) => const BasicWidgetsPage(),
        '/state_lifecycle': (context) => const StateLifecyclePage(),
        '/painter_demo': (context) => const PainterDemoPage(),
        '/repaint_boundary_demo': (context) => const RepaintBoundaryDemoPage(),
      },
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const demos = <_DemoLink>[
      _DemoLink(
        title: 'Basic Widgets Demo',
        subtitle: 'StatelessWidget vs StatefulWidget rebuild行为',
        routeName: '/basic_widgets',
      ),
      _DemoLink(
        title: 'State Lifecycle Demo',
        subtitle: 'StatefulWidget 生命周期 + setState',
        routeName: '/state_lifecycle',
      ),
      _DemoLink(
        title: 'Painter Demo',
        subtitle: 'CustomPainter 渲染阶段日志',
        routeName: '/painter_demo',
      ),
      _DemoLink(
        title: 'RepaintBoundary Demo',
        subtitle: '局部重绘与 RenderObject 隔离',
        routeName: '/repaint_boundary_demo',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 三棵树 & 生命周期示例'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '观察 Widget / Element / RenderObject 的关系以及生命周期日志',
              style: TextStyle(fontSize: 16),
            ),
          ),
          for (final demo in demos)
            ListTile(
              title: Text(demo.title),
              subtitle: Text(demo.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).pushNamed(demo.routeName),
            ),
        ],
      ),
    );
  }
}

class _DemoLink {
  final String title;
  final String subtitle;
  final String routeName;

  const _DemoLink({
    required this.title,
    required this.subtitle,
    required this.routeName,
  });
}

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

class PainterDemoPage extends StatefulWidget {
  const PainterDemoPage({super.key});

  @override
  State<PainterDemoPage> createState() => _PainterDemoPageState();
}

class _PainterDemoPageState extends State<PainterDemoPage> {
  double _radius = 60;

  @override
  Widget build(BuildContext context) {
    debugPrint('[PainterDemoPage] build radius=${_radius.toStringAsFixed(1)}');
    return Scaffold(
      appBar: AppBar(title: const Text('Painter Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CustomPainter 展示 build/layout/paint 分离'),
            const SizedBox(height: 12),
            Slider(
              value: _radius,
              min: 20,
              max: 140,
              label: _radius.toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  _radius = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 280,
                  height: 280,
                  // CustomPaint 是 RenderObjectWidget，会创建 RenderCustomPaint。
                  child: CustomPaint(
                    painter: PainterDemoPainter(radius: _radius),
                    child: const Center(child: Text('拖动 Slider 观察日志')), 
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PainterDemoPainter extends CustomPainter {
  final double radius;

  PainterDemoPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('[PainterDemoPainter] paint, radius=${radius.toStringAsFixed(1)}, size=$size');
    final center = size.center(Offset.zero);
    final axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), axisPaint);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), axisPaint);

    final fillPaint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, fillPaint);
    canvas.drawCircle(center, radius, strokePaint);
  }

  @override
  bool shouldRepaint(covariant PainterDemoPainter oldDelegate) {
    final should = oldDelegate.radius != radius;
    debugPrint(
      '[PainterDemoPainter] shouldRepaint: old=${oldDelegate.radius.toStringAsFixed(1)}, new=${radius.toStringAsFixed(1)}, should=$should',
    );
    return should;
  }
}

class RepaintBoundaryDemoPage extends StatefulWidget {
  const RepaintBoundaryDemoPage({super.key});

  @override
  State<RepaintBoundaryDemoPage> createState() => _RepaintBoundaryDemoPageState();
}

class _RepaintBoundaryDemoPageState extends State<RepaintBoundaryDemoPage> {
  int _colorIndex = 0;
  final List<Color> _colors = [
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[_colorIndex % _colors.length];
    debugPrint('[RepaintBoundaryDemoPage] build color=$color');
    return Scaffold(
      appBar: AppBar(title: const Text('RepaintBoundary Demo')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('对比没有/有 RepaintBoundary 时的局部重绘范围'),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('无 RepaintBoundary'),
                      Expanded(
                        child: CustomPaint(
                          painter: const NoBoundaryPainter(),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      const Text('有 RepaintBoundary'),
                      Expanded(
                        child: RepaintBoundary(
                          // RenderObject 树在此断开，只会重绘边界内的 RenderCustomPaint。
                          child: CustomPaint(
                            painter: BoundaryPainter(color: color),
                            child: const SizedBox.expand(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _colorIndex++;
                });
                debugPrint('[RepaintBoundaryDemoPage] changeColor -> index=$_colorIndex');
              },
              child: const Text('只改变右侧颜色'),
            ),
          ),
        ],
      ),
    );
  }
}

class NoBoundaryPainter extends CustomPainter {
  const NoBoundaryPainter();

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('[NoBoundaryPainter] paint, size=$size');
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant NoBoundaryPainter oldDelegate) {
    debugPrint('[NoBoundaryPainter] shouldRepaint -> false');
    return false;
  }
}

class BoundaryPainter extends CustomPainter {
  final Color color;

  BoundaryPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('[BoundaryPainter] paint, color=$color, size=$size');
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant BoundaryPainter oldDelegate) {
    final should = oldDelegate.color != color;
    debugPrint('[BoundaryPainter] shouldRepaint old=${oldDelegate.color}, new=$color, should=$should');
    return should;
  }
}
