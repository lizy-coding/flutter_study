import 'package:flutter/material.dart';
import 'package:flutter_forge_app/shared/learning/learning_scaffold.dart';

class WebUnavailablePage extends StatelessWidget {
  const WebUnavailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LearningScaffold(
      title: '在线视频播放',
      interactiveDemo: Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Web 端视频播放能力尚未通过浏览器验收。'),
        ),
      ),
      sections: [
        LearningObjectives(objectives: ['理解 Web 媒体播放的平台差异', '识别能力未验证时的降级边界']),
        CommonPitfalls(
          pitfalls: ['video_player_win 不是 Web 播放后端', '构建通过不代表浏览器可播放'],
        ),
      ],
    );
  }
}
