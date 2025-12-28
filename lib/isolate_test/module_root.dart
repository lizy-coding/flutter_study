import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String _baseRoute = '/isolate-test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Isolate 对比演示'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Isolate 测试与对比',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '本演示通过大量计算来对比使用和不使用 Isolate 的差异',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: const Column(
                children: [
                  Text(
                    '测试说明:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. 两个页面执行相同的计算任务(查找素数)\n'
                    '2. 计算过程中观察动画流畅度\n'
                    '3. 尝试点击"点击测试响应"按钮\n'
                    '4. 尝试在蓝色区域滑动\n'
                    '5. 对比两者UI响应差异',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.red[100],
              ),
              onPressed: () {
                context.push('$_baseRoute/without-isolate');
              },
              child: const Text('不使用 Isolate (卡顿示例)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.green[100],
              ),
              onPressed: () {
                context.push('$_baseRoute/with-isolate');
              },
              child: const Text('使用 Isolate (流畅示例)'),
            ),
          ],
        ),
      ),
    );
  }
}
