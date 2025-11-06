import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Riverpod 需要 ProviderScope 包裹根部
  runApp(const ProviderScope(child: StateFlowDemoApp()));
}

/// 教学 Demo：三种状态管理的完整数据流（状态变化 → 通知 → UI 重建）
class StateFlowDemoApp extends StatelessWidget {
  const StateFlowDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '状态管理数据流教学 Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const _HomeTabs(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// 顶部：三种实现的 Tab 切换
class _HomeTabs extends StatefulWidget {
  const _HomeTabs({super.key});

  @override
  State<_HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<_HomeTabs> {
  int _index = 0;

  final _pages = const [
    SetStateDemoPage(),
    ProviderDemoPage(),
    RiverpodDemoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(['setState', 'Provider', 'Riverpod'][_index]),
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.refresh), label: 'setState'),
          NavigationDestination(icon: Icon(Icons.extension), label: 'Provider'),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Riverpod'),
        ],
      ),
    );
  }
}

/* -----------------------------------------------------------
 * 1) setState 原理级最小闭环：状态变更 -> markNeedsBuild -> build
 * ----------------------------------------------------------*/
class SetStateDemoPage extends StatefulWidget {
  const SetStateDemoPage({super.key});

  @override
  State<SetStateDemoPage> createState() => _SetStateDemoPageState();
}

class _SetStateDemoPageState extends State<SetStateDemoPage> {
  int _counter = 0;

  void _increment() {
    debugPrint('[setState] 事件: 点击 +1, 旧值=$_counter');
    setState(() {
      _counter++;
      // setState 内部：标记当前 Element 脏 -> (下一帧) build 重建 -> diff -> 局部重绘
    });
    debugPrint('[setState] 新值=$_counter -> 框架将触发 build() 重建');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[setState] build() 执行, 当前值=$_counter');
    return _ScaffoldSection(
      title: 'setState: 最小可感知重建',
      subtitle: '状态保存在 State 中；setState 标记脏元素 -> 下一帧重建',
      value: _counter,
      onAdd: _increment,
      onReset: () {
        debugPrint('[setState] 重置 -> 0');
        setState(() => _counter = 0);
      },
    );
  }
}

/* -----------------------------------------------------------
 * 2) Provider (ChangeNotifier)：
 *    notifyListeners() -> Provider 触达依赖 -> markNeedsBuild -> build
 * ----------------------------------------------------------*/

/// 业务状态：计数器（ChangeNotifier 版本）
class CounterCN extends ChangeNotifier {
  int value = 0;

  void increment() {
    final old = value;
    value++;
    debugPrint('[Provider] increment(): $old -> $value');
    debugPrint('[Provider] notifyListeners(): 通知所有已注册的监听者');
    notifyListeners(); // Provider 捕获并触发依赖的 widgets 重新构建
  }

  void reset() {
    value = 0;
    debugPrint('[Provider] reset(): -> 0, notifyListeners()');
    notifyListeners();
  }
}

class ProviderDemoPage extends StatelessWidget {
  const ProviderDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 将 CounterCN 注入当前子树
    return ChangeNotifierProvider(
      create: (_) {
        debugPrint('[Provider] 创建 CounterCN 实例并注入子树');
        return CounterCN();
      },
      child: const _ProviderView(),
    );
  }
}

class _ProviderView extends StatelessWidget {
  const _ProviderView();

  @override
  Widget build(BuildContext context) {
    // watch 会在 value 变化并 notifyListeners 后触发本 Widget 重建
    final counter = context.watch<CounterCN>().value;
    debugPrint('[Provider] _ProviderView.build(): 读取 value=$counter');

    return _ScaffoldSection(
      title: 'Provider: ChangeNotifier 数据流',
      subtitle: 'notifyListeners() -> 依赖收集的消费者重建',
      value: counter,
      onAdd: () => context.read<CounterCN>().increment(),
      onReset: () => context.read<CounterCN>().reset(),
    );
  }
}

/* -----------------------------------------------------------
 * 3) Riverpod (StateNotifier + ProviderContainer)：
 *    state=new -> 触发 listeners -> Element.markNeedsBuild -> build
 * ----------------------------------------------------------*/

/// Riverpod 的 StateNotifier：只管理 state，不关心 UI
class CounterRP extends StateNotifier<int> {
  CounterRP() : super(0);

  void increment() {
    final old = state;
    state = state + 1; // 触发 Riverpod 的依赖更新链路
    debugPrint('[Riverpod] increment(): $old -> $state (触发监听者重建)');
  }

  void reset() {
    state = 0;
    debugPrint('[Riverpod] reset(): -> 0');
  }
}

/// Provider 声明：对外暴露 int 状态
final counterProvider = StateNotifierProvider<CounterRP, int>((ref) {
  debugPrint('[Riverpod] 创建 CounterRP 并被容器管理');
  return CounterRP();
});

class RiverpodDemoPage extends ConsumerWidget {
  const RiverpodDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch: 当 provider 的状态变更时，本 Widget 重建
    final count = ref.watch(counterProvider);
    debugPrint('[Riverpod] Consumer.build(): 读取 state=$count');

    return _ScaffoldSection(
      title: 'Riverpod: StateNotifier 数据流',
      subtitle: 'state 变更 -> 容器通知依赖 -> 重建消费者',
      value: count,
      onAdd: () => ref.read(counterProvider.notifier).increment(),
      onReset: () => ref.read(counterProvider.notifier).reset(),
    );
  }
}

/* -----------------------------------------------------------
 * 统一的展示组件（UI & 控件）
 * ----------------------------------------------------------*/
class _ScaffoldSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final VoidCallback onAdd;
  final VoidCallback onReset;

  const _ScaffoldSection({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onAdd,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            margin: const EdgeInsets.all(16),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.black54),
                  ),
                  const Divider(height: 32),
                  Text(
                    '$value',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: onAdd,
                        icon: const Icon(Icons.exposure_plus_1),
                        label: const Text('加 1'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: onReset,
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('重置'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '查看控制台日志（debugPrint）以观察：状态变更 → 通知 → build 重建',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
