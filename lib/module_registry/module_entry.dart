import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'module_category.dart';

class ModuleEntry {
  ModuleEntry({
    required this.title,
    required this.path,
    required this.builder,
    this.subtitle,
    this.category = ModuleCategory.basic,
    this.difficulty = Difficulty.beginner,
    this.concepts = const [],
    this.estimatedMinutes = 20,
    this.status = ModuleStatus.pending,
    this.routes = const [],
  });

  final String title;
  final String path;
  final WidgetBuilder builder;
  final String? subtitle;
  final ModuleCategory category;
  final Difficulty difficulty;
  final List<String> concepts;
  final int estimatedMinutes;
  final ModuleStatus status;
  final List<GoRoute> routes;
}
