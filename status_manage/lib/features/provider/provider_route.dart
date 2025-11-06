import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/widgets/state_flow_scaffold.dart';

class ProviderRoute extends StatelessWidget {
  const ProviderRoute({super.key});

  static const routeName = '/provider';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        debugPrint('[Provider] 创建 CounterCN，并开始监听 notifyListeners');
        return CounterCN();
      },
      child: Builder(
        builder: (context) {
          final counter = context.watch<CounterCN>();
          debugPrint('[Provider] UI build，读取 value=${counter.value}');

          return StateFlowScaffold(
            pageTitle: 'Provider / ChangeNotifier',
            subtitle: 'notifyListeners() -> Provider 找到依赖 -> markNeedsBuild() -> build',
            value: counter.value,
            flowSteps: const [
              'onPressed 事件',
              'value++',
              'notifyListeners()',
              '依赖 Widget 重建',
            ],
            onAdd: counter.increment,
            onReset: counter.reset,
          );
        },
      ),
    );
  }
}

/// ChangeNotifier 负责触发 `notifyListeners()`，Provider 会将它与 UI 解耦。
class CounterCN extends ChangeNotifier {
  int value = 0;

  void increment() {
    final before = value;
    value++;
    debugPrint('[Provider] increment: $before -> $value');
    notifyListeners();
  }

  void reset() {
    value = 0;
    debugPrint('[Provider] reset -> 0');
    notifyListeners();
  }
}
