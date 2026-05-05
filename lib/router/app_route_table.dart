import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../adsorption_line/module_entry.dart';
import '../debounce_throttle/module_entry.dart';
import '../download_animation_demo/module_entry.dart';
import '../download_animation_demo/module_routes.dart';
import '../flutter_ioc/module_entry.dart';
import '../interceptor_test/module_entry.dart';
import '../interceptor_test/module_routes.dart';
import '../isolate_stream_demo/module_entry.dart';
import '../isolate_test/module_entry.dart';
import '../isolate_test/module_routes.dart';
import '../microtask/module_entry.dart';
import '../microtask/module_routes.dart';
import '../pop_widget/module_entry.dart';
import '../scroll_table/module_entry.dart';
import '../status_manage/app/app_routes.dart';
import '../status_manage/module_entry.dart';
import '../stream_subscription/module_entry.dart';
import '../stream_subscription/module_routes.dart';
import '../tree_state/module_entry.dart';
import '../tree_state/module_routes.dart';
import '../usb_detector_demo/module_entry.dart';

// ==================== 枚举定义 ====================

/// 模块分类
enum ModuleCategory {
  basic('基础机制'),
  async('异步并发'),
  state('状态管理'),
  ui('UI 与动效'),
  network('网络与平台');

  const ModuleCategory(this.label);
  final String label;
}

/// 难度等级
enum Difficulty {
  beginner('入门'),
  intermediate('进阶'),
  advanced('实战');

  const Difficulty(this.label);
  final String label;
}

/// 模块状态
enum ModuleStatus {
  pending('待整改'),
  ready('可学习'),
  recommended('推荐');

  const ModuleStatus(this.label);
  final String label;
}

// ==================== 状态管理子路由（模块内部已定义映射） ====================

List<GoRoute> _buildStatusManageRoutes() => AppRoutes.routes.entries
    .map(
      (entry) => GoRoute(
        path: entry.key.startsWith('/') ? entry.key.substring(1) : entry.key,
        builder: (context, state) => entry.value(context),
      ),
    )
    .toList();

// ==================== 模块注册 ====================

final List<ModuleEntry> _modules = [
  // 基础机制
  ModuleEntry(
    title: '三棵树与生命周期',
    path: '/tree-state',
    subtitle: '理解 Widget/Element/RenderObject 的关系与重建机制',
    category: ModuleCategory.basic,
    difficulty: Difficulty.beginner,
    concepts: ['Widget 树', 'Element 树', 'RenderObject', '生命周期'],
    estimatedMinutes: 30,
    status: ModuleStatus.recommended,
    builder: (context) => const TreeStateEntry(),
    routes: TreeStateRoutes.routes,
  ),
  ModuleEntry(
    title: '事件循环与微任务',
    path: '/microtask',
    subtitle: '掌握 Dart 事件循环中微任务队列与事件队列的执行顺序',
    category: ModuleCategory.basic,
    difficulty: Difficulty.beginner,
    concepts: ['Microtask', 'Event Queue', 'async/await', 'Zone'],
    estimatedMinutes: 25,
    status: ModuleStatus.recommended,
    builder: (context) => const MicrotaskEntry(),
    routes: MicrotaskRoutes.routes,
  ),
  ModuleEntry(
    title: '防抖与节流',
    path: '/debounce-throttle',
    subtitle: '对比防抖和节流的执行时序，理解适用场景',
    category: ModuleCategory.basic,
    difficulty: Difficulty.beginner,
    concepts: ['Debouncer', 'Throttle', 'Timer'],
    estimatedMinutes: 15,
    status: ModuleStatus.ready,
    builder: (context) => const DebounceThrottleEntry(),
  ),

  // 异步并发
  ModuleEntry(
    title: 'Stream 订阅机制',
    path: '/stream-subscription',
    subtitle: '学习单订阅流与广播流的区别及使用场景',
    category: ModuleCategory.async,
    difficulty: Difficulty.intermediate,
    concepts: ['StreamController', '单订阅', '广播流', 'Stream 变换'],
    estimatedMinutes: 30,
    status: ModuleStatus.recommended,
    builder: (context) => const StreamSubscriptionEntry(),
    routes: StreamSubscriptionRoutes.routes,
  ),
  ModuleEntry(
    title: 'Isolate 并发对比',
    path: '/isolate-test',
    subtitle: '对比主线程与 Isolate 执行耗时计算对 UI 流畅度的影响',
    category: ModuleCategory.async,
    difficulty: Difficulty.intermediate,
    concepts: ['Isolate', 'SendPort', 'ReceivePort', '性能优化'],
    estimatedMinutes: 20,
    status: ModuleStatus.ready,
    builder: (context) => const IsolateTestEntry(),
    routes: IsolateTestRoutes.routes,
  ),
  ModuleEntry(
    title: '多任务 Isolate 管理器',
    path: '/isolate-stream',
    subtitle: '使用 Isolate 并行处理多任务，通过 Stream 实时上报进度',
    category: ModuleCategory.async,
    difficulty: Difficulty.advanced,
    concepts: ['Isolate.spawn', '多任务', '进度上报', '暂停/恢复'],
    estimatedMinutes: 35,
    status: ModuleStatus.ready,
    builder: (context) => const IsolateStreamEntry(),
  ),

  // 状态管理
  ModuleEntry(
    title: '状态管理演进',
    path: '/status-manage',
    subtitle: '串联 setState、Provider、Riverpod、Bloc，对比不同方案',
    category: ModuleCategory.state,
    difficulty: Difficulty.intermediate,
    concepts: ['Provider', 'Riverpod', 'Bloc', '状态提升', 'FutureProvider'],
    estimatedMinutes: 45,
    status: ModuleStatus.recommended,
    builder: (context) => const StatusManageEntry(),
    routes: _buildStatusManageRoutes(),
  ),
  ModuleEntry(
    title: 'Flutter IoC 容器',
    path: '/flutter-ioc',
    subtitle: '自研 IoC 容器实现，支持单例/瞬态/作用域生命周期',
    category: ModuleCategory.state,
    difficulty: Difficulty.advanced,
    concepts: ['IoC', '依赖注入', '生命周期', '作用域'],
    estimatedMinutes: 30,
    status: ModuleStatus.ready,
    builder: (context) => const FlutterIocEntry(),
  ),

  // UI 与动效
  ModuleEntry(
    title: '智能吸附线画板',
    path: '/adsorption-line',
    subtitle: '类似设计工具的对齐吸附功能，学习自定义绘制与手势',
    category: ModuleCategory.ui,
    difficulty: Difficulty.advanced,
    concepts: ['CustomPaint', '手势检测', '吸附算法', '状态管理'],
    estimatedMinutes: 40,
    status: ModuleStatus.ready,
    builder: (context) => const AdsorptionLineEntry(),
  ),
  ModuleEntry(
    title: '下载飞入动效',
    path: '/download-animation',
    subtitle: '三种实现方式对比：Custom View / CustomPaint / Overlay',
    category: ModuleCategory.ui,
    difficulty: Difficulty.intermediate,
    concepts: ['Tween 动画', 'CustomPaint', 'OverlayEntry', '动画配置'],
    estimatedMinutes: 30,
    status: ModuleStatus.ready,
    builder: (context) => const DownloadAnimationEntry(),
    routes: DownloadAnimationRoutes.routes,
  ),
  ModuleEntry(
    title: '弹窗合集',
    path: '/pop-widget',
    subtitle: '全面展示 Flutter 中的对话框、底部抽屉、菜单等弹窗类型',
    category: ModuleCategory.ui,
    difficulty: Difficulty.beginner,
    concepts: ['AlertDialog', 'BottomSheet', 'Overlay', 'ContextMenu'],
    estimatedMinutes: 20,
    status: ModuleStatus.ready,
    builder: (context) => const PopWidgetEntry(),
  ),
  ModuleEntry(
    title: '二维滚动表格',
    path: '/scroll-table',
    subtitle: '使用 two_dimensional_scrollables 实现固定表头的表格',
    category: ModuleCategory.ui,
    difficulty: Difficulty.beginner,
    concepts: ['TableView', '固定表头', '二维滚动'],
    estimatedMinutes: 15,
    status: ModuleStatus.pending,
    builder: (context) => const ScrollTableEntry(),
  ),

  // 网络与平台
  ModuleEntry(
    title: 'Dio 拦截器链路',
    path: '/interceptor-test',
    subtitle: 'Auth/Error/Retry/Log 拦截器 + 本地 Mock Server 实战',
    category: ModuleCategory.network,
    difficulty: Difficulty.intermediate,
    concepts: ['Dio', '拦截器', 'Token 刷新', 'Mock Server', '重试机制'],
    estimatedMinutes: 35,
    status: ModuleStatus.ready,
    builder: (context) => const InterceptorTestEntry(),
    routes: InterceptorTestRoutes.routes,
  ),
  ModuleEntry(
    title: 'USB 设备检测',
    path: '/usb-detector',
    subtitle: '跨平台 USB 设备检测与状态监控',
    category: ModuleCategory.network,
    difficulty: Difficulty.intermediate,
    concepts: ['usb_serial', 'device_info_plus', 'Stream 广播', '设备扫描'],
    estimatedMinutes: 25,
    status: ModuleStatus.pending,
    builder: (context) => const UsbDetectorEntry(),
  ),
];

// ==================== 路由聚合 ====================

final List<GoRoute> _routes = [
  GoRoute(
    path: '/',
    builder: (context, state) => ModuleHomePage(modules: _modules),
  ),
  for (final module in _modules)
    GoRoute(
      path: module.path,
      builder: (context, state) => module.builder(context),
      routes: module.routes,
    ),
];

class AppRouteTable {
  static List<GoRoute> get routes => _routes;
  static List<ModuleEntry> get modules => _modules;
}

// ==================== ModuleEntry 模型 ====================

class ModuleEntry {
  ModuleEntry({
    required this.title,
    required this.path,
    required this.builder,
    this.subtitle,
    this.category = ModuleCategory.basic,
    this.difficulty = Difficulty.beginner,
    this.concepts = const [],
    this.estimatedMinutes = 20,
    this.status = ModuleStatus.pending,
    this.routes = const [],
  });

  final String title;
  final String path;
  final WidgetBuilder builder;
  final String? subtitle;
  final ModuleCategory category;
  final Difficulty difficulty;
  final List<String> concepts;
  final int estimatedMinutes;
  final ModuleStatus status;
  final List<GoRoute> routes;
}

// ==================== 首页 ====================

class ModuleHomePage extends StatelessWidget {
  const ModuleHomePage({super.key, required this.modules});

  final List<ModuleEntry> modules;

  @override
  Widget build(BuildContext context) {
    final categories = ModuleCategory.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 学习实验室'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryModules =
              modules.where((m) => m.category == category).toList();

          if (categoryModules.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  category.label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ...categoryModules.map((module) => ModuleCard(module: module)),
              const Divider(height: 1),
            ],
          );
        },
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  const ModuleCard({super.key, required this.module});

  final ModuleEntry module;

  Color _difficultyColor(Difficulty d) {
    return switch (d) {
      Difficulty.beginner => Colors.green,
      Difficulty.intermediate => Colors.orange,
      Difficulty.advanced => Colors.red,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(module.title)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color:
                  _difficultyColor(module.difficulty).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              module.difficulty.label,
              style: TextStyle(
                fontSize: 11,
                color: _difficultyColor(module.difficulty),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (module.subtitle != null)
            Text(module.subtitle!, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: module.concepts
                .map(
                  (c) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(c, style: const TextStyle(fontSize: 10)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 4),
          Text(
            '预计 ${module.estimatedMinutes} 分钟 · ${module.status.label}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(module.path),
    );
  }
}
