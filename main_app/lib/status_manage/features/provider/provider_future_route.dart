import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderFutureRoute extends StatelessWidget {
  const ProviderFutureRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _UserModel()..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Provider 数据获取与缓存')),
        body: Center(
          child: Consumer<_UserModel>(
            builder: (_, m, __) => m.name == null
                ? const CircularProgressIndicator()
                : Text(m.name!, style: Theme.of(context).textTheme.headlineSmall),
          ),
        ),
      ),
    );
  }
}

class _UserModel extends ChangeNotifier {
  String? name;
  Future<void> load() async {
    await Future.delayed(const Duration(milliseconds: 300));
    name = 'Alice';
    notifyListeners();
  }
}