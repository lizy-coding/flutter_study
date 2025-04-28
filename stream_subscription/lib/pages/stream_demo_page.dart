import 'dart:async';
import 'package:flutter/material.dart';

/// Stream演示页面
class StreamDemoPage extends StatefulWidget {
  /// 构造函数
  const StreamDemoPage({super.key});

  @override
  State<StreamDemoPage> createState() => _StreamDemoPageState();
}

class _StreamDemoPageState extends State<StreamDemoPage> {
  // 用于存储接收到的消息
  final List<String> _receivedMessages = [];
  
  // 控制推送状态
  bool _isPushingActive = false;
  
  // 模拟推送的Stream控制器
  late StreamController<String> _streamController;
  
  // 订阅对象
  StreamSubscription<String>? _subscription;
  
  // 推送计数器
  int _pushCount = 0;
  
  // 推送间隔（秒）
  int _interval = 2;

  @override
  void initState() {
    super.initState();
    // 初始化Stream控制器
    _initStream();
  }

  // 初始化Stream
  void _initStream() {
    // 创建一个新的StreamController
    _streamController = StreamController<String>(
      // 当Stream被关闭时执行的回调
      onCancel: () {
        print('StreamController 被关闭');
      },
    );
  }

  // 开始推送消息
  void _startPushing() {
    if (_isPushingActive) return;
    
    setState(() {
      _isPushingActive = true;
    });
    
    // 模拟定期推送消息
    Timer.periodic(Duration(seconds: _interval), (timer) {
      if (!_isPushingActive) {
        timer.cancel();
        return;
      }
      
      _pushCount++;
      final message = '模拟消息 #$_pushCount - ${DateTime.now().toString().substring(11, 19)}';
      
      // 通过StreamController发送消息
      if (!_streamController.isClosed) {
        _streamController.add(message);
      }
    });
  }

  // 停止推送消息
  void _stopPushing() {
    setState(() {
      _isPushingActive = false;
    });
  }

  // 订阅Stream
  void _subscribe() {
    if (_subscription != null) {
      _showMessage('已经存在一个订阅，请先取消再重新订阅');
      return;
    }
    
    // 清空历史消息
    setState(() {
      _receivedMessages.clear();
    });
    
    // 创建订阅
    _subscription = _streamController.stream.listen(
      // 处理接收到的数据
      (data) {
        setState(() {
          _receivedMessages.add(data);
        });
      },
      // 处理错误
      onError: (error) {
        _showMessage('错误: $error');
      },
      // Stream完成时的回调
      onDone: () {
        _showMessage('Stream 已关闭');
        setState(() {
          _subscription = null;
        });
      },
    );
    
    _showMessage('已成功订阅');
  }

  // 取消订阅
  void _unsubscribe() {
    if (_subscription == null) {
      _showMessage('当前没有活动的订阅');
      return;
    }
    
    _subscription!.cancel().then((_) {
      setState(() {
        _subscription = null;
      });
      _showMessage('已取消订阅');
    });
  }

  // 添加错误事件
  void _addError() {
    if (!_isPushingActive) {
      _showMessage('请先开始推送');
      return;
    }
    
    if (!_streamController.isClosed) {
      _streamController.addError('模拟的错误事件');
      _showMessage('已添加一个错误事件');
    }
  }

  // 关闭Stream
  void _closeStream() {
    if (_streamController.isClosed) {
      _showMessage('Stream 已经关闭');
      return;
    }
    
    // 先停止推送
    _stopPushing();
    
    // 关闭StreamController
    _streamController.close().then((_) {
      _showMessage('Stream 已关闭');
      
      // 重新初始化Stream以便再次使用
      _initStream();
    });
  }

  // 显示提示消息
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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

  @override
  void dispose() {
    // 确保在组件销毁时关闭Stream
    if (!_streamController.isClosed) {
      _streamController.close();
    }
    // 取消订阅
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const Text('控制面板', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                          onPressed: _subscription != null ? null : _subscribe,
                          child: const Text('订阅'),
                        ),
                        ElevatedButton(
                          onPressed: _subscription == null ? null : _unsubscribe,
                          child: const Text('取消订阅'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                          items: [1, 2, 3, 5].map((value) {
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
            const Text(
              '接收到的消息:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                child: _receivedMessages.isEmpty
                    ? const Center(child: Text('暂无消息'))
                    : ListView.builder(
                        itemCount: _receivedMessages.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.message),
                            title: Text(_receivedMessages[index]),
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '状态: ${_isPushingActive ? "推送中" : "已停止"} | ${_subscription != null ? "已订阅" : "未订阅"}',
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
