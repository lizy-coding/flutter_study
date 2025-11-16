import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodTodoRoute extends ConsumerWidget {
  const RiverpodTodoRoute({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod 全局状态示例')),
      body: const _TodoBody(),
      floatingActionButton: const _AddFab(),
    );
  }
}

class _Todo {
  _Todo(this.title, {this.done = false});
  final String title;
  bool done;
}

class _TodoRP extends StateNotifier<List<_Todo>> {
  _TodoRP() : super([]);
  void add(String t) => state = [...state, _Todo(t)];
  void toggle(int i) {
    final l = [...state];
    l[i].done = !l[i].done;
    state = l;
  }
  void remove(int i) {
    final l = [...state]..removeAt(i);
    state = l;
  }
}

final _todoProvider = StateNotifierProvider<_TodoRP, List<_Todo>>((ref) => _TodoRP());

class _TodoBody extends ConsumerWidget {
  const _TodoBody({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(_todoProvider);
    final n = ref.read(_todoProvider.notifier);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
        return ListTile(
          title: Text(item.title),
          leading: Checkbox(value: item.done, onChanged: (_) => n.toggle(i)),
          trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => n.remove(i)),
        );
      },
    );
  }
}

class _AddFab extends ConsumerWidget {
  const _AddFab({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.read(_todoProvider.notifier);
    return FloatingActionButton(
      onPressed: () => n.add('Item ${ref.read(_todoProvider).length + 1}'),
      child: const Icon(Icons.add),
    );
  }
}