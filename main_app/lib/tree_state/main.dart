import 'package:flutter/material.dart';

import 'pages/basic_widgets_page.dart';
import 'pages/demo_home_page.dart';
import 'pages/painter_demo_page.dart';
import 'pages/repaint_boundary_demo_page.dart';
import 'pages/state_lifecycle_page.dart';
import 'routes.dart';

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
      // 所有示例页面集中在此路由表，便于统一调整。
      routes: {
        DemoRoutes.basicWidgets: (context) => const BasicWidgetsPage(),
        DemoRoutes.stateLifecycle: (context) => const StateLifecyclePage(),
        DemoRoutes.painterDemo: (context) => const PainterDemoPage(),
        DemoRoutes.repaintBoundary: (context) => const RepaintBoundaryDemoPage(),
      },
    );
  }
}
