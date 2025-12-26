import 'package:flutter/material.dart';

import 'module_root.dart' as isolate_test;

class IsolateTestEntry extends StatelessWidget {
  const IsolateTestEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const isolate_test.HomePage();
  }
}
