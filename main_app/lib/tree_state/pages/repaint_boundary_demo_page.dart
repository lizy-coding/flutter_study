import 'package:flutter/material.dart';

/// 对比使用/不使用 RepaintBoundary 时的重绘范围，方便解释 RenderObject 分叉。
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
