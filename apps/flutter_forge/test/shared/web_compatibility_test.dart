@TestOn('browser')
library;

import 'package:flutter/material.dart';
import 'package:flutter_forge_app/app/router/app_route_table.dart';
import 'package:flutter_forge_app/module_registry/module_catalog_utils.dart';
import 'package:flutter_forge_app/modules/platform/file_picker/module_entry.dart';
import 'package:flutter_forge_app/modules/platform/online_video_player/module_entry.dart';
import 'package:flutter_forge_app/modules/ui/font_picker/module_entry.dart';
import 'package:flutter_forge_app/modules/ui/gcode_visualizer/module_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Web catalog keeps native-only capabilities unavailable', () {
    for (final path in [
      '/dio-interceptor',
      '/file-picker',
      '/online-video-player',
      '/webview',
      '/gcode-visualizer',
      '/usb-detector',
    ]) {
      final module = AppRouteTable.modules.singleWhere(
        (entry) => entry.path == path,
      );
      expect(isModuleAvailable(module), isFalse, reason: path);
    }
  });

  test('Dio restriction does not claim or remove native host support', () {
    final module = AppRouteTable.modules.singleWhere(
      (entry) => entry.path == '/dio-interceptor',
    );

    for (final platform in [
      TargetPlatform.android,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    ]) {
      expect(isModuleAvailable(module, platform, false), isTrue);
    }
    expect(module.supportedPlatforms, isNull);
    expect(module.supportsWeb, isFalse);
  });

  testWidgets('Web entries render safe compatibility states', (tester) async {
    for (final entry in const <Widget>[
      FilePickerEntry(),
      OnlineVideoPlayerEntry(),
      FontPickerEntry(),
      GcodeVisualizerEntry(),
    ]) {
      await tester.pumpWidget(MaterialApp(home: entry));
      expect(tester.takeException(), isNull);
    }

    expect(find.textContaining('Web'), findsWidgets);
  });
}
