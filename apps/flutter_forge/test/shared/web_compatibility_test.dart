@TestOn('browser')
library;

import 'package:flutter/material.dart';
import 'package:flutter_forge_app/app/router/app_route_table.dart';
import 'package:flutter_forge_app/module_registry/module_catalog_utils.dart';
import 'package:flutter_forge_app/modules/platform/dio_interceptor/module_entry.dart';
import 'package:flutter_forge_app/modules/platform/file_picker/module_entry.dart';
import 'package:flutter_forge_app/modules/platform/online_video_player/state/video_player_adapter.dart';
import 'package:flutter_forge_app/modules/ui/font_picker/module_entry.dart';
import 'package:flutter_forge_app/modules/ui/gcode_visualizer/module_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Web catalog keeps native-only capabilities unavailable', () {
    for (final path in [
      '/file-picker',
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

  test('Web catalog exposes the connected Dio and video modules', () {
    for (final path in ['/dio-interceptor', '/online-video-player']) {
      final module = AppRouteTable.modules.singleWhere(
        (entry) => entry.path == path,
      );
      expect(isModuleAvailable(module), isTrue, reason: path);
      expect(module.supportsWeb, isTrue, reason: path);
    }
  });

  test('Web video policy skips probing and waits for a user gesture', () {
    final adapter = VideoPlayerPluginAdapter();

    expect(adapter.probeBeforeOpen, isFalse);
    expect(adapter.startAutomatically, isFalse);
    adapter.dispose();
  });

  test('Dio Web support does not fabricate a native host allowlist', () {
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
    expect(module.supportsWeb, isTrue);
  });

  testWidgets('Web entries render safe compatibility states', (tester) async {
    for (final entry in const <Widget>[
      InterceptorTestEntry(),
      FilePickerEntry(),
      FontPickerEntry(),
      GcodeVisualizerEntry(),
    ]) {
      await tester.pumpWidget(MaterialApp(home: entry));
      expect(tester.takeException(), isNull);
    }

    expect(find.textContaining('Web'), findsWidgets);
  });
}
