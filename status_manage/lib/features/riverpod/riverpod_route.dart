import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/state_flow_scaffold.dart';

class RiverpodRoute extends ConsumerWidget {
  const RiverpodRoute({super.key});

  static const routeName = '/riverpod';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    debugPrint('[Riverpod] Consumer build，state=$count');

    return StateFlowScaffold(
      pageTitle: 'Riverpod / StateNotifier',
      subtitle: 'state = newState -> ProviderContainer 广播 -> 订阅者重建',
      value: count,
      flowSteps: const [
        'onPressed 事件',
        'state = newState',
        '容器 diff 并广播',
        '监听者 build()',
      ],
      onAdd: () => ref.read(counterProvider.notifier).increment(),
      onReset: () => ref.read(counterProvider.notifier).reset(),
    );
  }
}

/// Riverpod 方案：StateNotifier 专注在状态流转，UI 仅订阅 Provider。
final counterProvider = StateNotifierProvider<CounterRP, int>((ref) {
  debugPrint('[Riverpod] 创建 CounterRP');
  return CounterRP();
});

class CounterRP extends StateNotifier<int> {
  CounterRP() : super(0);

  void increment() {
    final old = state;
    state = state + 1;
    debugPrint('[Riverpod] increment: $old -> $state (自动通知依赖)');
  }

  void reset() {
    state = 0;
    debugPrint('[Riverpod] reset -> 0');
  }
}
