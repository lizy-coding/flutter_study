import 'package:flutter/material.dart';

import '../features/provider/provider_route.dart';
import '../features/riverpod/riverpod_route.dart';

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
        StateFlowHome.routeName: (_) => const StateFlowHome(),
        ProviderRoute.routeName: (_) => const ProviderRoute(),
        RiverpodRoute.routeName: (_) => const RiverpodRoute(),
      },
      initialRoute: StateFlowHome.routeName,
      debugShowCheckedModeBanner: false,
    );
  }
}

/// 首页：用卡片讲清楚「事件 → 状态 → UI」链路，并跳转到对应插件页面。
class StateFlowHome extends StatelessWidget {
  const StateFlowHome({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final cards = [
      _HomeCardData(
        title: 'Provider / ChangeNotifier',
        flow: '事件处理 → value 变化 → notifyListeners → Consumer 重建',
        icon: Icons.extension,
        routeName: ProviderRoute.routeName,
        chipLabel: '依赖收集 + 多个 Widget 共享',
      ),
      _HomeCardData(
        title: 'Riverpod / StateNotifier',
        flow: '事件处理 → state = newState → container 广播 → Consumer 重建',
        icon: Icons.sync_alt,
        routeName: RiverpodRoute.routeName,
        chipLabel: '声明式 Provider 图谱',
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
