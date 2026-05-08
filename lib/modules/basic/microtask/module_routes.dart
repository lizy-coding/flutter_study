import 'package:go_router/go_router.dart';

import 'features/event_queue/event_queue_page.dart';
import 'features/microtask_queue/microtask_queue_page.dart';
import 'features/advanced_examples/advanced_examples_page.dart';

/// 事件循环与微任务模块子路由
class MicrotaskRoutes {
  MicrotaskRoutes._();

  static const String eventQueue = '/event-queue';
  static const String microtaskQueue = '/microtask-queue';
  static const String advanced = '/advanced';

  static List<GoRoute> get routes => [
        GoRoute(
          path: 'event-queue',
          builder: (_, __) => const EventQueuePage(),
        ),
        GoRoute(
          path: 'microtask-queue',
          builder: (_, __) => const MicrotaskQueuePage(),
        ),
        GoRoute(
          path: 'advanced',
          builder: (_, __) => const AdvancedExamplesPage(),
        ),
      ];
}
