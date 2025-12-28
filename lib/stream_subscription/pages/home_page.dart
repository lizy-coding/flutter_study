import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 应用主页
class HomePage extends StatelessWidget {
  /// 构造函数
  const  HomePage({super.key});

  static const String _baseRoute = '/stream-subscription';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Stream 学习'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Stream 基础学习',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Stream 是 Flutter 中处理异步数据流的核心工具，其流式推送机制通过持续发送数据事件实现动态响应。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            _buildExampleCard(
              context,
              title: '单订阅 Stream 示例',
              description: '单订阅流只允许一个监听器，适用于点对点通信场景',
              icon: Icons.person,
              color: Colors.blue,
              onTap: () {
                context.push('$_baseRoute/stream-demo');
              },
            ),
            const SizedBox(height: 20),
            _buildExampleCard(
              context,
              title: '广播 Stream 示例',
              description: '广播流允许多个监听器，适用于一对多通信场景',
              icon: Icons.people,
              color: Colors.green,
              onTap: () {
                context.push('$_baseRoute/broadcast-demo');
              },
            ),
            const SizedBox(height: 20),
            _buildExampleCard(
              context,
              title: 'Stream 变换示例',
              description: '使用各种操作符对数据流进行变换处理',
              icon: Icons.transform,
              color: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('此功能暂未实现，敬请期待！'),
                  ),
                );
              },
            ),
            const Spacer(),
            const Center(
              child: Text(
                '© 2025 Stream 学习项目',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建示例卡片
  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
