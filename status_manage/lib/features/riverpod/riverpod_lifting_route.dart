import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodLiftingRoute extends ConsumerWidget {
  const RiverpodLiftingRoute({super.key});

  static const routeName = '/riverpod/lifting';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod 状态提升')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _LDisplay(),
                SizedBox(height: 16),
                _LControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _liftProvider = StateNotifierProvider<_LiftRP, int>((ref) => _LiftRP());

class _LiftRP extends StateNotifier<int> {
  _LiftRP() : super(0);
  void inc() => state = state + 1;
  void reset() => state = 0;
}

class _LDisplay extends ConsumerWidget {
  const _LDisplay({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(_liftProvider.select((v) => v));
    return Text('$v', style: Theme.of(context).textTheme.headlineMedium);
  }
}

class _LControls extends ConsumerWidget {
  const _LControls({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.read(_liftProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.icon(onPressed: n.inc, icon: const Icon(Icons.exposure_plus_1), label: const Text('加 1')),
        const SizedBox(width: 12),
        OutlinedButton.icon(onPressed: n.reset, icon: const Icon(Icons.restart_alt), label: const Text('重置')),
      ],
    );
  }
}