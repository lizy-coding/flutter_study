import 'dart:io' show Platform;

bool get multiWindowPlatformSupported =>
    Platform.isMacOS || Platform.isWindows || Platform.isLinux;
