import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/state_flow_app.dart';

void main() {
  // Riverpod 仍然需要 ProviderScope 作为根；其他路由也能共享容器
  runApp(const ProviderScope(child: StateFlowApp()));
}
