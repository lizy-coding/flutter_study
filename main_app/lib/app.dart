import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'adsorption_line/state/drawing_state.dart';
import 'adsorption_line/widgets/drawing_board.dart';
import 'debounce_throttle/main.dart' as debounce_throttle;
import 'download_animation_demo/main.dart' as download_animation_demo;
import 'flutter_ioc/ioc/ioc.dart' as ioc;
import 'flutter_ioc/main.dart' as flutter_ioc;
import 'flutter_ioc/model/counter_model.dart';
import 'interceptor_test/mock_server/mock_server.dart';
import 'interceptor_test/pages/home_page.dart' as interceptor_test;
import 'isolate_stream_demo/main.dart' as isolate_stream_demo;
import 'isolate_test/main.dart' as isolate_test;
import 'microtask/features/home_page.dart' as microtask;
import 'pop_widget/main.dart' as pop_widget;
import 'scroll_table/main.dart' as scroll_table;
import 'status_manage/app/app_routes.dart';
import 'status_manage/app/state_flow_app.dart';
import 'stream_subscription/pages/home_page.dart' as stream_subscription;
import 'tree_state/pages/basic_widgets_page.dart';
import 'tree_state/pages/demo_home_page.dart';
import 'tree_state/pages/painter_demo_page.dart';
import 'tree_state/pages/repaint_boundary_demo_page.dart';
import 'tree_state/pages/state_lifecycle_page.dart';
import 'tree_state/routes.dart';
import 'usb_detector_demo/main.dart' as usb_detector_demo;

class App extends StatelessWidget {
  App({super.key});

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) => ModuleHomePage(modules: _modules),
      ),
      for (final module in _modules)
        GoRoute(
          path: module.path,
          builder: (context, state) => module.builder(context),
          routes: module.routes,
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Main App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}

class ModuleEntry {
  ModuleEntry({
    required this.title,
    required this.path,
    required this.builder,
    this.subtitle,
    this.routes = const [],
  });

  final String title;
  final String path;
  final WidgetBuilder builder;
  final String? subtitle;
  final List<GoRoute> routes;
}

final List<GoRoute> _statusManageRoutes = AppRoutes.routes.entries
    .map(
      (entry) => GoRoute(
        path: _stripLeadingSlash(entry.key),
        builder: (context, state) => entry.value(context),
      ),
    )
    .toList();

final List<GoRoute> _treeStateRoutes = [
  GoRoute(
    path: _stripLeadingSlash(DemoRoutes.basicWidgets),
    builder: (context, state) => const BasicWidgetsPage(),
  ),
  GoRoute(
    path: _stripLeadingSlash(DemoRoutes.stateLifecycle),
    builder: (context, state) => const StateLifecyclePage(),
  ),
  GoRoute(
    path: _stripLeadingSlash(DemoRoutes.painterDemo),
    builder: (context, state) => const PainterDemoPage(),
  ),
  GoRoute(
    path: _stripLeadingSlash(DemoRoutes.repaintBoundary),
    builder: (context, state) => const RepaintBoundaryDemoPage(),
  ),
];

final List<ModuleEntry> _modules = [
  ModuleEntry(
    title: 'Adsorption Line',
    path: '/adsorption-line',
    builder: (context) => ChangeNotifierProvider(
      create: (_) => DrawingState(),
      child: const DrawingBoard(),
    ),
  ),
  ModuleEntry(
    title: 'Debounce & Throttle',
    path: '/debounce-throttle',
    builder: (context) => const debounce_throttle.MyHomePage(
      title: 'Debounce & Throttle',
    ),
  ),
  ModuleEntry(
    title: 'Download Animation',
    path: '/download-animation',
    builder: (context) => const download_animation_demo.HomePage(),
  ),
  ModuleEntry(
    title: 'Flutter IoC',
    path: '/flutter-ioc',
    builder: (context) => const FlutterIocShell(),
  ),
  ModuleEntry(
    title: 'Interceptor Test',
    path: '/interceptor-test',
    builder: (context) => const InterceptorTestShell(),
  ),
  ModuleEntry(
    title: 'Isolate Stream',
    path: '/isolate-stream',
    builder: (context) => const isolate_stream_demo.MultiTaskIsolatePage(
      title: 'Isolate Stream Demo',
    ),
  ),
  ModuleEntry(
    title: 'Isolate Test',
    path: '/isolate-test',
    builder: (context) => const isolate_test.HomePage(),
  ),
  ModuleEntry(
    title: 'Microtask',
    path: '/microtask',
    builder: (context) => const microtask.HomePage(),
  ),
  ModuleEntry(
    title: 'Pop Widget',
    path: '/pop-widget',
    builder: (context) => const pop_widget.PopDemoHomePage(
      title: 'Pop Widget Demo',
    ),
  ),
  ModuleEntry(
    title: 'Scroll Table',
    path: '/scroll-table',
    builder: (context) => const scroll_table.ScrollTableDemo(),
  ),
  ModuleEntry(
    title: 'Status Manage',
    path: '/status-manage',
    builder: (context) => const StateFlowHome(),
    routes: _statusManageRoutes,
  ),
  ModuleEntry(
    title: 'Stream Subscription',
    path: '/stream-subscription',
    builder: (context) => const stream_subscription.HomePage(),
  ),
  ModuleEntry(
    title: 'Tree State',
    path: '/tree-state',
    builder: (context) => const DemoHomePage(),
    routes: _treeStateRoutes,
  ),
  ModuleEntry(
    title: 'USB Detector',
    path: '/usb-detector',
    builder: (context) => const usb_detector_demo.MyHomePage(
      title: 'USB Detector',
    ),
  ),
];

class ModuleHomePage extends StatelessWidget {
  const ModuleHomePage({super.key, required this.modules});

  final List<ModuleEntry> modules;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Modules'),
      ),
      body: ListView.separated(
        itemCount: modules.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final module = modules[index];
          return ListTile(
            title: Text(module.title),
            subtitle: Text(module.subtitle ?? module.path),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(module.path),
          );
        },
      ),
    );
  }
}

class FlutterIocShell extends StatefulWidget {
  const FlutterIocShell({super.key});

  @override
  State<FlutterIocShell> createState() => _FlutterIocShellState();
}

class _FlutterIocShellState extends State<FlutterIocShell> {
  late final ioc.Container _container;

  @override
  void initState() {
    super.initState();
    _container = ioc.Container(environment: {'appName': 'Counter'});
    _container.registerSingleton<CounterModel>(
      (_) => CounterModel(name: 'Default', count: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ioc.IoCContainer>.value(
      value: _container,
      child: ChangeNotifierProvider<CounterModel>(
        create: (_) => _container.resolve<CounterModel>(),
        child: const flutter_ioc.CounterScreen(),
      ),
    );
  }
}

class InterceptorTestShell extends StatefulWidget {
  const InterceptorTestShell({super.key});

  @override
  State<InterceptorTestShell> createState() => _InterceptorTestShellState();
}

class _InterceptorTestShellState extends State<InterceptorTestShell> {
  final MockServer _server = MockServer();
  late final Future<void> _startFuture;

  @override
  void initState() {
    super.initState();
    _startFuture = _server.start();
  }

  @override
  void dispose() {
    _server.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _startFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _LoadingPage(title: 'Starting mock server');
        }
        return const interceptor_test.HomePage();
      },
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}

String _stripLeadingSlash(String path) {
  if (path.startsWith('/')) {
    return path.substring(1);
  }
  return path;
}
