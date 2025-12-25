import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/widgets/state_flow_scaffold.dart';
import 'models/counter_cn.dart';
import 'widgets/provider_perks.dart';
import 'widgets/granular_grid.dart';


class ProviderRoute extends StatelessWidget {
  const ProviderRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        debugPrint('[Provider] 创建 CounterCN，并开始监听 notifyListeners');
        return CounterCN();
      },
      child: Builder(
        builder: (context) {
          final value = context.select<CounterCN, int>((s) => s.value);
          debugPrint('[Provider] 顶层 build，仅监听 value=$value');
          final counter = context.read<CounterCN>();

          return StateFlowScaffold(
            pageTitle: 'Provider / ChangeNotifier',
            subtitle:
                'notifyListeners() -> Provider 找到依赖字段 -> markNeedsBuild() 仅重建对应 Widget',
            value: value,
            flowSteps: const [
              'onPressed 事件（任意层）',
              'value++ / leafTaps++',
              'notifyListeners()',
              '依赖字段的 Widget 重建',
            ],
            onAdd: counter.increment,
            onReset: counter.reset,
            extra: const ProviderPerks(),
          );
        },
      ),
    );
  }
}
