import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'module_category.dart';

class ModuleEntry {
  ModuleEntry({
    required this.title,
    required this.path,
    required this.subtitle,
    required this.category,
    required this.difficulty,
    required this.concepts,
    required this.estimatedMinutes,
    required this.status,
    required this.builder,
    this.routes = const [],
    this.supportedPlatforms,
    this.supportsWeb,
  });

  final String title;
  final String path;
  final String subtitle;
  final ModuleCategory category;
  final Difficulty difficulty;
  final List<String> concepts;
  final int estimatedMinutes;
  final ModuleStatus status;
  final WidgetBuilder builder;
  final List<GoRoute> routes;

  /// Null means the module is platform-neutral and supported by default.
  /// A non-null set restricts availability to the listed host platforms.
  final Set<TargetPlatform>? supportedPlatforms;

  /// Overrides Web availability independently from native host support.
  ///
  /// Platform-neutral modules support Web by default. Set this to false when
  /// an otherwise platform-neutral module depends on a native-only runtime
  /// capability. A module with an explicit [supportedPlatforms] set is
  /// unavailable on Web unless this is explicitly true.
  final bool? supportsWeb;

  bool isSupportedOn(TargetPlatform platform, {required bool isWeb}) {
    if (isWeb) return supportsWeb ?? supportedPlatforms == null;
    final platforms = supportedPlatforms;
    return platforms == null || platforms.contains(platform);
  }
}
