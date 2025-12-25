import 'package:flutter/material.dart';
import 'stream_demo_controller.dart';

/// Stream演示页面
class StreamDemoPage extends StatefulWidget {
  /// 构造函数
  const StreamDemoPage({super.key});

  @override
  State<StreamDemoPage> createState() => _StreamDemoPageState();
}

class _StreamDemoPageState extends State<StreamDemoPage> {
  /// 控制器：封装业务逻辑与状态
  late final StreamDemoController controller;

  /// 列表滚动控制器
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = StreamDemoController();
    controller.addListener(() {
      if (_scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => child!,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stream 单订阅示例'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '控制面板',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed:
                                controller.isPushing ? null : controller.start,
                            child: const Text('开始推送'),
                          ),
                          ElevatedButton(
                            onPressed:
                                !controller.isPushing ? null : controller.stop,
                            child: const Text('停止推送'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed:
                                !controller.isSubscribed
                                    ? null
                                    : controller.unsubscribe,
                            child: const Text('订阅'),
                          ),
                          ElevatedButton(
                            onPressed:
                                controller.isSubscribed
                                    ? null
                                    : controller.subscribe,
                            child: const Text('取消订阅'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: controller.addError,
                            child: const Text('添加错误'),
                          ),
                          ElevatedButton(
                            onPressed: controller.closeStream,
                            child: const Text('关闭Stream'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('推送间隔: '),
                          DropdownButton<int>(
                            value: controller.interval,
                            items:
                                [1, 2, 3, 5].map((value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text('$value秒'),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) controller.setInterval(value);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '接收到的消息:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Card(
                  child:
                      controller.messages.isEmpty
                          ? const Center(child: Text('暂无消息'))
                          : ListView.builder(
                            controller: _scrollController,
                            itemCount: controller.messages.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.message),
                                title: Text(controller.messages[index]),
                              );
                            },
                          ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '状态: ${controller.isPushing ? "推送中" : "已停止"} | ${controller.isSubscribed ? "已订阅" : "未订阅"}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: controller.isPushing ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
