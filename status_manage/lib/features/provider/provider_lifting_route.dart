import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderLiftingRoute extends StatelessWidget {
  const ProviderLiftingRoute({super.key});

  static const routeName = '/provider/lifting';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _LiftingCN(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Provider 状态提升')),
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
      ),
    );
  }
}

class _LiftingCN extends ChangeNotifier {
  int value = 0;
  void inc() {
    value++;
    notifyListeners();
  }
  void reset() {
    value = 0;
    notifyListeners();
  }
}

class _LDisplay extends StatelessWidget {
  const _LDisplay({super.key});
  @override
  Widget build(BuildContext context) {
    final v = context.select<_LiftingCN, int>((s) => s.value);
    return Text('$v', style: Theme.of(context).textTheme.headlineMedium);
  }
}

class _LControls extends StatelessWidget {
  const _LControls({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.read<_LiftingCN>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.icon(onPressed: s.inc, icon: const Icon(Icons.exposure_plus_1), label: const Text('加 1')),
        const SizedBox(width: 12),
        OutlinedButton.icon(onPressed: s.reset, icon: const Icon(Icons.restart_alt), label: const Text('重置')),
      ],
    );
  }
}