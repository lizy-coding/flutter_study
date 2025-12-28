import 'package:flutter/material.dart';
import '../features/provider/provider_route.dart';
import '../features/provider/provider_lifting_route.dart';
import '../features/provider/provider_future_route.dart';
import '../features/provider/provider_todo_route.dart';
import '../features/riverpod/riverpod_route.dart';
import '../features/riverpod/riverpod_lifting_route.dart';
import '../features/riverpod/riverpod_future_route.dart';
import '../features/riverpod/riverpod_todo_route.dart';
import 'route_paths.dart';
import '../features/bloc/bloc_route.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    RoutePaths.provider: (_) => const ProviderRoute(),
    RoutePaths.providerLifting: (_) => const ProviderLiftingRoute(),
    RoutePaths.providerFuture: (_) => const ProviderFutureRoute(),
    RoutePaths.providerTodo: (_) => const ProviderTodoRoute(),
    RoutePaths.riverpod: (_) => const RiverpodRoute(),
    RoutePaths.riverpodLifting: (_) => const RiverpodLiftingRoute(),
    RoutePaths.riverpodFuture: (_) => const RiverpodFutureRoute(),
    RoutePaths.riverpodTodo: (_) => const RiverpodTodoRoute(),
    RoutePaths.bloc: (_) => const BlocRoute(),
  };
}
