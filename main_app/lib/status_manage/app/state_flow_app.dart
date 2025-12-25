import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'route_paths.dart';

/// 根部 MaterialApp，集中声明路由，避免示例全部堆在 main.dart 中。
class StateFlowApp extends StatelessWidget {
  const StateFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '状态刷新流学习 Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        visualDensity: VisualDensity.standard,
      ),
      routes: {
        RoutePaths.home: (_) => const StateFlowHome(),
        ...AppRoutes.routes,
      },
      initialRoute: RoutePaths.home,
      debugShowCheckedModeBanner: false,
    );
  }
}

/// 首页：用卡片讲清楚「事件 → 状态 → UI」链路，并跳转到对应插件页面。
class StateFlowHome extends StatelessWidget {
  const StateFlowHome({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = <_RouteCategory>[
      _RouteCategory(
        title: 'Provider',
        description: '基于 InheritedWidget + ChangeNotifier，侧重依赖收集与粒度刷新',
        badge: 'Widget 树驱动',
        icon: Icons.extension,
        routes: const [
          _HomeCardData(
            title: '基础 / 粒度刷新',
            flow: '事件 → notifyListeners → Selector 仅重建依赖字段',
            icon: Icons.auto_fix_high,
            routeName: RoutePaths.provider,
            chipLabel: 'ChangeNotifier',
          ),
          _HomeCardData(
            title: '状态提升',
            flow: '父级集中管理 → 子组件共享',
            icon: Icons.vertical_align_top,
            routeName: RoutePaths.providerLifting,
            chipLabel: 'props 上提',
          ),
          _HomeCardData(
            title: '数据获取',
            flow: '异步加载 → 缓存 → 重建',
            icon: Icons.cloud_download,
            routeName: RoutePaths.providerFuture,
            chipLabel: 'FutureBuilder 缓存',
          ),
          _HomeCardData(
            title: '全局 Todo',
            flow: '列表变更 → notifyListeners',
            icon: Icons.checklist,
            routeName: RoutePaths.providerTodo,
            chipLabel: 'ChangeNotifier',
          ),
        ],
      ),
      _RouteCategory(
        title: 'Riverpod',
        description: '容器化 Provider 图谱，无需 context，自动依赖追踪',
        badge: '声明式',
        icon: Icons.sync_alt,
        routes: const [
          _HomeCardData(
            title: 'StateNotifier 基础',
            flow: '事件 → state=new → 容器广播 → 重建',
            icon: Icons.sync_alt,
            routeName: RoutePaths.riverpod,
            chipLabel: '声明式图谱',
          ),
          _HomeCardData(
            title: '状态提升',
            flow: 'Provider 图谱共享',
            icon: Icons.vertical_align_top,
            routeName: RoutePaths.riverpodLifting,
            chipLabel: 'StateNotifierProvider',
          ),
          _HomeCardData(
            title: '数据获取',
            flow: 'FutureProvider → when()',
            icon: Icons.cloud_download,
            routeName: RoutePaths.riverpodFuture,
            chipLabel: '缓存与错误处理',
          ),
          _HomeCardData(
            title: '全局 Todo',
            flow: '列表不可变 → state 赋值广播',
            icon: Icons.checklist,
            routeName: RoutePaths.riverpodTodo,
            chipLabel: 'StateNotifier',
          ),
        ],
      ),
      _RouteCategory(
        title: 'Bloc',
        description: '事件流驱动：Event → Bloc → emit(State)',
        badge: '事件驱动',
        icon: Icons.scatter_plot,
        routes: const [
          _HomeCardData(
            title: 'flutter_bloc 基础',
            flow: 'Event → Bloc → emit(State) → 重建',
            icon: Icons.scatter_plot,
            routeName: RoutePaths.bloc,
            chipLabel: '事件流 + 不可变状态',
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('状态刷新流总览'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final category in categories)
            _RouteCategoryCard(category: category),
        ],
      ),
    );
  }
}

class _RouteCategoryCard extends StatelessWidget {
  const _RouteCategoryCard({required this.category});

  final _RouteCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(category.icon, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.title, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text(
                        category.description,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Chip(
                  avatar: const Icon(Icons.filter_alt_outlined, size: 16),
                  label: Text(category.badge),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                for (var i = 0; i < category.routes.length; i++) ...[
                  _RouteListTile(data: category.routes[i]),
                  if (i != category.routes.length - 1)
                    const Divider(height: 16),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteListTile extends StatelessWidget {
  const _RouteListTile({required this.data});

  final _HomeCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(data.routeName),
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(data.icon, color: theme.colorScheme.secondary),
      ),
      title: Text(data.title, style: theme.textTheme.titleMedium),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          '刷新链路：${data.flow}',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ),
      trailing: Chip(
        avatar: const Icon(Icons.visibility, size: 16),
        label: Text(data.chipLabel),
      ),
    );
  }
}

class _RouteCategory {
  const _RouteCategory({
    required this.title,
    required this.description,
    required this.badge,
    required this.icon,
    required this.routes,
  });

  final String title;
  final String description;
  final String badge;
  final IconData icon;
  final List<_HomeCardData> routes;
}

class _HomeCardData {
  const _HomeCardData({
    required this.title,
    required this.flow,
    required this.icon,
    required this.routeName,
    required this.chipLabel,
  });

  final String title;
  final String flow;
  final IconData icon;
  final String routeName;
  final String chipLabel;
}
