import 'package:flutter/material.dart';
import 'pages/download_animation_page.dart';
import 'models/animation_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '下载动画演示',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DownloadAnimationPage(
        // 可以在这里传入自定义动画配置
        animationConfig: AnimationConfig(
          animationDuration: 2000,
          flyingItemOffset: 80,
          flyingItemPadding: 8,
          flyingItemRadius: 8,
        ),
      ),
    );
  }
}
