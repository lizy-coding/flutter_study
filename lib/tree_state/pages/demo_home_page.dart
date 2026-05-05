import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../module_routes.dart';

/// 主页列出所有示例入口，便于在调试时快速跳转。
class DemoHomePage extends StatelessWidget {
  static const String _baseRoute = '/tree-state';

  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const demos = <_DemoLink>[
      _DemoLink(
        title: '基础 Widget 重建',
        subtitle: 'StatelessWidget vs StatefulWidget 重建行为',
        routeName: TreeStateRoutes.basicWidgets,
      ),
      _DemoLink(
        title: 'State 生命周期',
        subtitle: 'StatefulWidget 生命周期 + setState',
        routeName: TreeStateRoutes.stateLifecycle,
      ),
      _DemoLink(
        title: 'CustomPainter 渲染',
        subtitle: 'CustomPainter 渲染阶段日志',
        routeName: TreeStateRoutes.painterDemo,
      ),
      _DemoLink(
        title: 'RepaintBoundary',
        subtitle: '局部重绘与 RenderObject 隔离',
        routeName: TreeStateRoutes.repaintBoundary,
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
              onTap: () => context.push('$_baseRoute${demo.routeName}'),
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
