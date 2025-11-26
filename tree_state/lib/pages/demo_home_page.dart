import 'package:flutter/material.dart';

import '../routes.dart';

/// 主页列出所有示例入口，便于在调试时快速跳转。
class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const demos = <_DemoLink>[
      _DemoLink(
        title: 'Basic Widgets Demo',
        subtitle: 'StatelessWidget vs StatefulWidget rebuild行为',
        routeName: DemoRoutes.basicWidgets,
      ),
      _DemoLink(
        title: 'State Lifecycle Demo',
        subtitle: 'StatefulWidget 生命周期 + setState',
        routeName: DemoRoutes.stateLifecycle,
      ),
      _DemoLink(
        title: 'Painter Demo',
        subtitle: 'CustomPainter 渲染阶段日志',
        routeName: DemoRoutes.painterDemo,
      ),
      _DemoLink(
        title: 'RepaintBoundary Demo',
        subtitle: '局部重绘与 RenderObject 隔离',
        routeName: DemoRoutes.repaintBoundary,
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
