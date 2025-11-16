import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderTodoRoute extends StatelessWidget {
  const ProviderTodoRoute({super.key});

  static const routeName = '/provider/todo';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _TodoStore(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Provider 全局状态示例')),
        body: const _TodoBody(),
        floatingActionButton: const _AddFab(),
      ),
    );
  }
}

class _Todo {
  _Todo(this.title, {this.done = false});
  final String title;
  bool done;
}

class _TodoStore extends ChangeNotifier {
  final List<_Todo> list = [];
  void add(String t) {
    list.add(_Todo(t));
    notifyListeners();
  }
  void toggle(int i) {
    list[i].done = !list[i].done;
    notifyListeners();
  }
  void remove(int i) {
    list.removeAt(i);
    notifyListeners();
  }
}

class _TodoBody extends StatelessWidget {
  const _TodoBody({super.key});
  @override
  Widget build(BuildContext context) {
    final store = context.watch<_TodoStore>();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: store.list.length,
      itemBuilder: (_, i) {
        final item = store.list[i];
        return ListTile(
          title: Text(item.title),
          leading: Checkbox(value: item.done, onChanged: (_) => store.toggle(i)),
          trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => store.remove(i)),
        );
      },
    );
  }
}

class _AddFab extends StatelessWidget {
  const _AddFab({super.key});
  @override
  Widget build(BuildContext context) {
    final store = context.read<_TodoStore>();
    return FloatingActionButton(
      onPressed: () => store.add('Item ${store.list.length + 1}'),
      child: const Icon(Icons.add),
    );
  }
}