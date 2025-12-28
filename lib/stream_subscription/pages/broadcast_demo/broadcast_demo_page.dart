import 'dart:async';
import 'package:flutter/material.dart';

/// 广播Stream演示页面
class BroadcastDemoPage extends StatefulWidget {
  /// 构造函数
  const BroadcastDemoPage({super.key});

  @override
  State<BroadcastDemoPage> createState() => _BroadcastDemoPageState();
}

class _BroadcastDemoPageState extends State<BroadcastDemoPage> {
  // 广播Stream控制器
  late StreamController<String> _broadcastController;

  // 控制推送状态
  bool _isPushingActive = false;

  // 推送计数器
  int _pushCount = 0;

  // 推送间隔
  int _interval = 2;

  // 定时器
  Timer? _timer;

  // 订阅列表
  final List<_Subscriber> _subscribers = [];

  @override
  void initState() {
    super.initState();
    _initBroadcastStream();
  }

  // 初始化广播Stream
  void _initBroadcastStream() {
    _broadcastController = StreamController<String>.broadcast(
      onListen: () {
        print('有人开始监听广播Stream');
      },
      onCancel: () {
        print('有人取消监听广播Stream');
      },
    );
  }

  // 开始推送消息
  void _startPushing() {
    if (_isPushingActive) return;

    setState(() {
      _isPushingActive = true;
    });

    _timer = Timer.periodic(Duration(seconds: _interval), (timer) {
      if (!_isPushingActive) {
        timer.cancel();
        _timer = null;
        return;
      }

      _pushCount++;
      final message =
          '广播消息 #$_pushCount - ${DateTime.now().toString().substring(11, 19)}';

      if (!_broadcastController.isClosed) {
        _broadcastController.add(message);
      }
    });

    _showMessage('开始推送消息');
  }

  // 停止推送消息
  void _stopPushing() {
    if (!_isPushingActive) return;

    setState(() {
      _isPushingActive = false;
    });

    _timer?.cancel();
    _timer = null;

    _showMessage('停止推送消息');
  }

  // 添加新订阅者
  void _addSubscriber() {
    final subscriberId = _subscribers.length + 1;
    final subscriber = _Subscriber(
      id: subscriberId,
      name: '订阅者 $subscriberId',
      subscription: _broadcastController.stream.listen(
        (data) {
          // 实际情况中，这里不应该调用setState，因为这会导致整个页面刷新
          // 这里为了简单演示，采用这种方式
          setState(() {
            _subscribers
                .firstWhere((s) => s.id == subscriberId)
                .messages
                .add(data);
          });
        },
        onError: (error) {
          _showMessage('订阅者 $subscriberId 收到错误: $error');
        },
        onDone: () {
          _showMessage('订阅者 $subscriberId 的Stream已关闭');
        },
      ),
    );

    setState(() {
      _subscribers.add(subscriber);
    });

    _showMessage('添加了新订阅者: ${subscriber.name}');
  }

  // 移除订阅者
  void _removeSubscriber(int id) {
    final subscriber = _subscribers.firstWhere((s) => s.id == id);
    subscriber.subscription.cancel();

    setState(() {
      _subscribers.remove(subscriber);
    });

    _showMessage('移除了订阅者: ${subscriber.name}');
  }

  // 添加错误事件
  void _addError() {
    if (!_isPushingActive) {
      _showMessage('请先开始推送');
      return;
    }

    if (!_broadcastController.isClosed) {
      _broadcastController.addError('模拟的广播错误事件');
      _showMessage('添加了错误事件');
    }
  }

  // 关闭Stream
  void _closeStream() {
    if (_broadcastController.isClosed) {
      _showMessage('Stream已经关闭');
      return;
    }

    _stopPushing();
    _broadcastController.close();

    // 重新初始化Stream以便再次使用
    _initBroadcastStream();

    setState(() {
      // 清空所有订阅者
      _subscribers.clear();
    });

    _showMessage('Stream已关闭，所有订阅已移除');
  }

  // 修改推送间隔
  void _changeInterval(int newInterval) {
    if (newInterval < 1) return;

    setState(() {
      _interval = newInterval;
    });

    if (_isPushingActive) {
      _stopPushing();
      _startPushing();
    }

    _showMessage('推送间隔已设置为 $_interval 秒');
  }

  // 显示提示消息
  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    // 停止推送
    _timer?.cancel();

    // 取消所有订阅
    for (var subscriber in _subscribers) {
      subscriber.subscription.cancel();
    }

    // 关闭控制器
    if (!_broadcastController.isClosed) {
      _broadcastController.close();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream 广播订阅示例'),
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
                          onPressed: _isPushingActive ? null : _startPushing,
                          child: const Text('开始推送'),
                        ),
                        ElevatedButton(
                          onPressed: !_isPushingActive ? null : _stopPushing,
                          child: const Text('停止推送'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _addSubscriber,
                          child: const Text('添加订阅者'),
                        ),
                        ElevatedButton(
                          onPressed: _addError,
                          child: const Text('添加错误'),
                        ),
                        ElevatedButton(
                          onPressed: _closeStream,
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
                          value: _interval,
                          items:
                              [1, 2, 3, 5].map((value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value秒'),
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value != null) _changeInterval(value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '订阅者 (${_subscribers.length}):',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  _subscribers.isEmpty
                      ? const Center(child: Text('暂无订阅者，请添加'))
                      : ListView.builder(
                        itemCount: _subscribers.length,
                        itemBuilder: (context, index) {
                          final subscriber = _subscribers[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(subscriber.name),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        () => _removeSubscriber(subscriber.id),
                                  ),
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '收到的消息 (${subscriber.messages.length}):',
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  child:
                                      subscriber.messages.isEmpty
                                          ? const Center(child: Text('暂无消息'))
                                          : ListView.builder(
                                            itemCount:
                                                subscriber.messages.length,
                                            itemBuilder: (
                                              context,
                                              messageIndex,
                                            ) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 4.0,
                                                    ),
                                                child: Text(
                                                  subscriber
                                                      .messages[messageIndex],
                                                  style: TextStyle(
                                                    color: Colors.blue.shade700,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 8),
            Text(
              '状态: ${_isPushingActive ? "推送中" : "已停止"} | ' +
                  '订阅者数量: ${_subscribers.length}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isPushingActive ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 订阅者模型
class _Subscriber {
  /// 订阅者ID
  final int id;

  /// 订阅者名称
  final String name;

  /// 订阅对象
  final StreamSubscription<String> subscription;

  /// 接收到的消息
  final List<String> messages = [];

  /// 构造函数
  _Subscriber({
    required this.id,
    required this.name,
    required this.subscription,
  });
}
