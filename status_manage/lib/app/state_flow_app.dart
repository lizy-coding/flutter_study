import 'package:flutter/material.dart';
import 'package:status_manage/features/provider/provider_future_route.dart';
import 'package:status_manage/features/provider/provider_lifting_route.dart';
import 'package:status_manage/features/provider/provider_route.dart';
import 'package:status_manage/features/provider/provider_todo_route.dart';
import 'package:status_manage/features/riverpod/riverpod_future_route.dart';
import 'package:status_manage/features/riverpod/riverpod_lifting_route.dart';
import 'package:status_manage/features/riverpod/riverpod_route.dart';
import 'package:status_manage/features/riverpod/riverpod_todo_route.dart';

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
    final cards = [
      _HomeCardData(
        title: 'Provider / ChangeNotifier',
        flow: '事件 → value → notifyListeners → Consumer 重建',
        icon: Icons.extension,
        routeName: RoutePaths.provider,
        chipLabel: '依赖收集',
      ),
      _HomeCardData(
        title: 'Provider / 状态提升',
        flow: '父级集中管理 → 子组件共享',
        icon: Icons.vertical_align_top,
        routeName: RoutePaths.providerLifting,
        chipLabel: 'props + 上提',
      ),
      _HomeCardData(
        title: 'Provider / 数据获取',
        flow: '异步加载 → 缓存 → 重建',
        icon: Icons.cloud_download,
        routeName: RoutePaths.providerFuture,
        chipLabel: 'FutureBuilder / 缓存',
      ),
      _HomeCardData(
        title: 'Provider / 全局 Todo',
        flow: '列表变更 → notifyListeners',
        icon: Icons.checklist,
        routeName: RoutePaths.providerTodo,
        chipLabel: 'ChangeNotifier',
      ),
      _HomeCardData(
        title: 'Riverpod / StateNotifier',
        flow: '事件 → state=new → 容器广播 → 重建',
        icon: Icons.sync_alt,
        routeName: RoutePaths.riverpod,
        chipLabel: '声明式图谱',
      ),
      _HomeCardData(
        title: 'Riverpod / 状态提升',
        flow: 'Provider 图谱共享',
        icon: Icons.vertical_align_top,
        routeName: RoutePaths.riverpodLifting,
        chipLabel: 'StateNotifierProvider',
      ),
      _HomeCardData(
        title: 'Riverpod / 数据获取',
        flow: 'FutureProvider → when()',
        icon: Icons.cloud_download,
        routeName: RoutePaths.riverpodFuture,
        chipLabel: '缓存与错误处理',
      ),
      _HomeCardData(
        title: 'Riverpod / 全局 Todo',
        flow: '列表不可变 → state 赋值广播',
        icon: Icons.checklist,
        routeName: RoutePaths.riverpodTodo,
        chipLabel: 'StateNotifier',
      ),
      _HomeCardData(
        title: 'Bloc / flutter_bloc',
        flow: 'Event → Bloc → emit(State) → 重建',
        icon: Icons.scatter_plot,
        routeName: RoutePaths.bloc,
        chipLabel: '事件驱动 / 不可变状态',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('状态刷新流总览'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.of(context).pushNamed(card.routeName),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(card.icon, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(card.title, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          Text(
                            '刷新链路：${card.flow}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Chip(
                              avatar: const Icon(Icons.visibility, size: 16),
                              label: Text(card.chipLabel),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
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
