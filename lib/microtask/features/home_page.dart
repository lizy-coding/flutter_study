import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String _baseRoute = '/microtask';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 事件机制学习'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Flutter 事件循环与异步编程',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Flutter的事件处理机制基于事件循环(Event Loop)模型，包含两个关键队列：',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: '微任务队列 (Microtask Queue)',
              description: '处理高优先级的异步操作，总是在事件任务之前执行',
              icon: Icons.fast_forward,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              title: '事件队列 (Event Queue)',
              description: '处理普通异步操作，如I/O、计时器和用户输入等',
              icon: Icons.event,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            const Text(
              '学习内容',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildNavigationCard(
                    context,
                    title: '事件队列',
                    description: '学习事件队列的基本概念和使用方式',
                    icon: Icons.queue,
                    color: Colors.red.shade100,
                    routePath: '$_baseRoute/event-queue',
                  ),
                  _buildNavigationCard(
                    context,
                    title: '微任务队列',
                    description: '学习微任务队列的特性和优先级',
                    icon: Icons.speed,
                    color: Colors.blue.shade100,
                    routePath: '$_baseRoute/microtask-queue',
                  ),
                  _buildNavigationCard(
                    context,
                    title: '高级示例',
                    description: '探索async/await、Future链和Zone',
                    icon: Icons.code,
                    color: Colors.purple.shade100,
                    routePath: '$_baseRoute/advanced',
                  ),
                  _buildResourceCard(
                    title: '学习资源',
                    description: '查看更多关于Flutter事件机制的学习资源',
                    icon: Icons.book,
                    color: Colors.green.shade100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String routePath,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: InkWell(
        onTap: () => context.push(routePath),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.grey[800]),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(color: Colors.grey[800]),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.grey[800],
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: InkWell(
        onTap: () {
          // 实际项目中可能会打开一个资源列表页面
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.grey[800]),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(color: Colors.grey[800]),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResourceLink('Flutter官方文档'),
                  _buildResourceLink('Dart异步编程指南'),
                  _buildResourceLink('事件循环和隔离区'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.link, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
