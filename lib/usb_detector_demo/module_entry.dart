import 'package:flutter/material.dart';

import 'module_root.dart' as usb_detector_demo;

class UsbDetectorEntry extends StatelessWidget {
  const UsbDetectorEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return const usb_detector_demo.MyHomePage(title: 'USB设备检测器');
  }
}
