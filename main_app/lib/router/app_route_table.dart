import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../adsorption_line/module_entry.dart';
import '../debounce_throttle/module_entry.dart';
import '../download_animation_demo/module_entry.dart';
import '../flutter_ioc/module_entry.dart';
import '../interceptor_test/module_entry.dart';
import '../isolate_stream_demo/module_entry.dart';
import '../isolate_test/module_entry.dart';
import '../microtask/module_entry.dart';
import '../pop_widget/module_entry.dart';
import '../scroll_table/module_entry.dart';
import '../status_manage/app/app_routes.dart';
import '../status_manage/module_entry.dart';
import '../stream_subscription/module_entry.dart';
import '../tree_state/pages/basic_widgets_page.dart';
import '../tree_state/pages/painter_demo_page.dart';
import '../tree_state/pages/repaint_boundary_demo_page.dart';
import '../tree_state/pages/state_lifecycle_page.dart';
import '../tree_state/routes.dart';
import '../tree_state/module_entry.dart';
import '../usb_detector_demo/module_entry.dart';

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
    builder: (context) => const AdsorptionLineEntry(),
  ),
  ModuleEntry(
    title: 'Debounce & Throttle',
    path: '/debounce-throttle',
    builder: (context) => const DebounceThrottleEntry(),
  ),
  ModuleEntry(
    title: 'Download Animation',
    path: '/download-animation',
    builder: (context) => const DownloadAnimationEntry(),
  ),
  ModuleEntry(
    title: 'Flutter IoC',
    path: '/flutter-ioc',
    builder: (context) => const FlutterIocEntry(),
  ),
  ModuleEntry(
    title: 'Interceptor Test',
    path: '/interceptor-test',
    builder: (context) => const InterceptorTestEntry(),
  ),
  ModuleEntry(
    title: 'Isolate Stream',
    path: '/isolate-stream',
    builder: (context) => const IsolateStreamEntry(),
  ),
  ModuleEntry(
    title: 'Isolate Test',
    path: '/isolate-test',
    builder: (context) => const IsolateTestEntry(),
  ),
  ModuleEntry(
    title: 'Microtask',
    path: '/microtask',
    builder: (context) => const MicrotaskEntry(),
  ),
  ModuleEntry(
    title: 'Pop Widget',
    path: '/pop-widget',
    builder: (context) => const PopWidgetEntry(),
  ),
  ModuleEntry(
    title: 'Scroll Table',
    path: '/scroll-table',
    builder: (context) => const ScrollTableEntry(),
  ),
  ModuleEntry(
    title: 'Status Manage',
    path: '/status-manage',
    builder: (context) => const StatusManageEntry(),
    routes: _statusManageRoutes,
  ),
  ModuleEntry(
    title: 'Stream Subscription',
    path: '/stream-subscription',
    builder: (context) => const StreamSubscriptionEntry(),
  ),
  ModuleEntry(
    title: 'Tree State',
    path: '/tree-state',
    builder: (context) => const TreeStateEntry(),
    routes: _treeStateRoutes,
  ),
  ModuleEntry(
    title: 'USB Detector',
    path: '/usb-detector',
    builder: (context) => const UsbDetectorEntry(),
  ),
];

final List<GoRoute> _routes = [
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
];

class AppRouteTable {
  static List<GoRoute> get routes => _routes;
  static List<ModuleEntry> get modules => _modules;
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

String _stripLeadingSlash(String path) {
  if (path.startsWith('/')) {
    return path.substring(1);
  }
  return path;
}
