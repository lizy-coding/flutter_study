import 'package:flutter/material.dart';
import 'package:flutter_forge_app/shared/learning/learning_scaffold.dart';

class FilePickerWebPage extends StatelessWidget {
  const FilePickerWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LearningScaffold(
      title: '文件选择器',
      interactiveDemo: Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Web 文件选择后端尚未验证，当前不会调用原生 MethodChannel。'),
        ),
      ),
      sections: [
        LearningObjectives(objectives: ['理解 Web 文件选择的权限边界', '避免在 Web 上使用原生通道']),
        CommonPitfalls(pitfalls: ['Web 不提供可信的本地绝对路径', '构建通过不代表文件选择已验收']),
      ],
    );
  }
}
