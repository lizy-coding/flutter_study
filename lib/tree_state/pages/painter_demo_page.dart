import 'package:flutter/material.dart';

/// CustomPainter 的布局/重绘示例，日志标记了 build、shouldRepaint、paint 调用。
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
      ..color = Colors.blueAccent.withValues(alpha: 0.3)
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
