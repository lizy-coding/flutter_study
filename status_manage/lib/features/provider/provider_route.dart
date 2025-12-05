import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/widgets/state_flow_scaffold.dart';

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
            extra: const _ProviderPerks(),
          );
        },
      ),
    );
  }
}

/// ChangeNotifier 负责触发 `notifyListeners()`，Provider 会将它与 UI 解耦。
class CounterCN extends ChangeNotifier {
  int value = 0;
  int leafTaps = 0;

  void increment() {
    final before = value;
    value++;
    debugPrint('[Provider] increment: $before -> $value');
    notifyListeners();
  }

  void leafIncrement() {
    leafTaps++;
    debugPrint('[Provider] leaf tap -> $leafTaps (叶子直接调用 ChangeNotifier)');
    notifyListeners();
  }

  void reset() {
    value = 0;
    leafTaps = 0;
    debugPrint('[Provider] reset -> 0');
    notifyListeners();
  }
}

/// 额外展示 Provider 优势：无需 props 传递，叶子也可按字段粒度刷新。
class _ProviderPerks extends StatelessWidget {
  const _ProviderPerks();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('深层组件直接拿到上层状态', style: theme.textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(
          'ChangeNotifierProvider 挂在页面顶层，最深层的叶子通过 context.read/select 获取祖先状态与操作，完全不需要 props 层层传递。',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 12),
        const _DeepTree(),
        const SizedBox(height: 18),
        Text('颗粒度刷新（Selector / context.select）', style: theme.textTheme.titleMedium),
        const SizedBox(height: 6),
        Text(
          '不同区域只监听自己关心的字段：点击叶子不会让顶部数值重建，反之亦然。控制台日志可看到哪些 build() 被触发。',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 12),
        const _GranularGrid(),
      ],
    );
  }
}

class _DeepTree extends StatelessWidget {
  const _DeepTree();

  @override
  Widget build(BuildContext context) {
    debugPrint('[Provider] _DeepTree build（未订阅，不随状态刷新）');
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: const _TreeLevelOne(),
    );
  }
}

class _TreeLevelOne extends StatelessWidget {
  const _TreeLevelOne();

  @override
  Widget build(BuildContext context) {
    debugPrint('[Provider] Level 1 build（纯布局，不依赖 Provider）');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Level 1：布局层（未监听 Provider，不会重建）'),
        SizedBox(height: 8),
        _TreeLevelTwo(),
      ],
    );
  }
}

class _TreeLevelTwo extends StatelessWidget {
  const _TreeLevelTwo();

  @override
  Widget build(BuildContext context) {
    debugPrint('[Provider] Level 2 build（继续透传，无 props）');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Level 2：普通 Widget（未持有任何状态字段）'),
          SizedBox(height: 6),
          _TreeLeaf(),
        ],
      ),
    );
  }
}

class _TreeLeaf extends StatelessWidget {
  const _TreeLeaf();

  @override
  Widget build(BuildContext context) {
    final leafTaps = context.select<CounterCN, int>((s) => s.leafTaps);
    final ancestorValue = context.select<CounterCN, int>((s) => s.value);
    debugPrint('[Provider] 最深叶子 build：leafTaps=$leafTaps, ancestor value=$ancestorValue');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Level 3（叶子）：直接读取 Provider，跨越两层父 Widget',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 6),
          Text(
            '祖先 value：$ancestorValue | 叶子按钮点击：$leafTaps',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: context.read<CounterCN>().leafIncrement,
                icon: const Icon(Icons.touch_app_outlined),
                label: const Text('叶子直接触发事件'),
              ),
              OutlinedButton.icon(
                onPressed: context.read<CounterCN>().increment,
                icon: const Icon(Icons.exposure_plus_1),
                label: const Text('叶子也能改 value'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GranularGrid extends StatelessWidget {
  const _GranularGrid();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const [
        _GranularCard(
          title: '只监听 value',
          desc: '点击顶部「加 1」会触发重建，叶子按钮不会。',
          selector: _GranularSelector.value,
        ),
        _GranularCard(
          title: '只监听 leafTaps',
          desc: '只有叶子按钮触发，展示 Provider 的依赖分割。',
          selector: _GranularSelector.leafTaps,
        ),
      ],
    );
  }
}

enum _GranularSelector { value, leafTaps }

class _GranularCard extends StatelessWidget {
  const _GranularCard({
    required this.title,
    required this.desc,
    required this.selector,
  });

  final String title;
  final String desc;
  final _GranularSelector selector;

  @override
  Widget build(BuildContext context) {
    final selected = context.select<CounterCN, int>((s) {
      switch (selector) {
        case _GranularSelector.value:
          return s.value;
        case _GranularSelector.leafTaps:
          return s.leafTaps;
      }
    });
    debugPrint('[Provider] $title 重建，选中值=$selected');

    final scheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 240),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: scheme.secondaryContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(desc, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            Text(
              '$selected',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
