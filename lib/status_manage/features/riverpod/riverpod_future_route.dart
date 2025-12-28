import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodFutureRoute extends ConsumerWidget {
  const RiverpodFutureRoute({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_userProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod 数据获取与缓存')),
      body: Center(
        child: async.when(
          data: (v) => Text(v, style: Theme.of(context).textTheme.headlineSmall),
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
        ),
      ),
    );
  }
}

final _userProvider = FutureProvider<String>((ref) async {
  await Future.delayed(const Duration(milliseconds: 300));
  return 'Alice';
});