import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:isolate';
import 'dart:async';

class WithIsolatePage extends StatefulWidget {
  const WithIsolatePage({super.key});

  @override
  State<WithIsolatePage> createState() => _WithIsolatePageState();
}

class _WithIsolatePageState extends State<WithIsolatePage> with SingleTickerProviderStateMixin {
  bool _isCalculating = false;
  String _result = '';
  double _progress = 0.0;
  Stopwatch _stopwatch = Stopwatch();
  
  // 添加动画控制器和动画值
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _counter = 0;
  
  @override
  void initState() {
    super.initState();
    // 创建动画控制器
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // 创建动画
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // 增加计数器
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('使用 Isolate'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '这个示例使用 Isolate 在后台线程执行大量计算，期间界面保持流畅',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isCalculating ? null : _startHeavyCalculation,
              child: Text(_isCalculating ? '计算中...' : '开始计算'),
            ),
            const SizedBox(height: 10),
            
            // 添加计数器和按钮来测试UI响应
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Text('点击测试响应'),
                ),
                const SizedBox(width: 20),
                Text('计数: $_counter', style: const TextStyle(fontSize: 18)),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 添加动画元素
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                      stops: [0, _animation.value],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      '这个动画应该平滑运行',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '尝试滑动和点击，感受界面响应',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('结果:'),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(_result),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startHeavyCalculation() {
    setState(() {
      _isCalculating = true;
      _result = '计算中...\n';
      _progress = 0.0;
      _stopwatch.reset();
      _stopwatch.start();
    });

    // 使用 isolate 执行大量计算
    _findPrimesWithIsolate();
  }

  void _findPrimesWithIsolate() async {
    // 增加迭代次数和计算范围，与不使用 isolate 的版本保持一致
    final int iterations = 20;
    final int maxNumber = 500000;

    // 创建发送和接收端口
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();

    // 启动 isolate
    await Isolate.spawn(
      _isolateEntryPoint,
      _IsolateMessage(
        sendPort: receivePort.sendPort,
        iterations: iterations,
        maxNumber: maxNumber,
      ),
      onError: errorPort.sendPort,
    );

    // 监听错误
    errorPort.listen((error) {
      setState(() {
        _isCalculating = false;
        _result += '\n发生错误: $error';
      });
    });

    // 处理 isolate 的返回消息
    await for (final message in receivePort) {
      if (message is _ProgressMessage) {
        setState(() {
          _progress = message.progress;
          _result += '迭代 ${message.iteration}/$iterations 开始...\n';
          _result += '找到 ${message.primeCount} 个素数 (≤ $maxNumber)\n';
        });
      } else if (message is _ResultMessage) {
        _stopwatch.stop();
        setState(() {
          _isCalculating = false;
          _progress = 1.0;
          _result += '\n计算完成! 耗时: ${_stopwatch.elapsedMilliseconds / 1000} 秒';
        });
        
        // 关闭端口
        receivePort.close();
        errorPort.close();
        break;
      }
    }
  }
}

// Isolate 入口点 - 必须是顶层函数或静态方法
void _isolateEntryPoint(_IsolateMessage message) {
  final int iterations = message.iterations;
  final int maxNumber = message.maxNumber;

  for (int i = 0; i < iterations; i++) {
    // 计算素数
    List<int> primes = _calculatePrimes(maxNumber);
    
    // 发送进度消息
    message.sendPort.send(_ProgressMessage(
      iteration: i + 1,
      progress: i / iterations,
      primeCount: primes.length,
    ));
  }

  // 发送完成消息
  message.sendPort.send(_ResultMessage());
}

// 计算素数的方法 - 与不使用 isolate 的版本相同
List<int> _calculatePrimes(int max) {
  List<int> primes = [];
  
  // 埃拉托斯特尼筛法 (Sieve of Eratosthenes)
  List<bool> sieve = List.filled(max + 1, true);
  sieve[0] = sieve[1] = false;
  
  for (int i = 2; i <= sqrt(max).floor(); i++) {
    if (sieve[i]) {
      for (int j = i * i; j <= max; j += i) {
        sieve[j] = false;
      }
    }
  }
  
  // 额外增加更多计算量，使计算更耗时
  for (int number = 2; number <= max; number++) {
    if (sieve[number]) {
      // 增加一些额外的计算
      double sum = 0;
      for (int j = 0; j < 2000; j++) {
        sum += sin(j * 0.01) * cos(j * 0.01) * tan(j * 0.005);
      }
      primes.add(number);
    }
  }
  
  return primes;
}

// 用于 isolate 通信的消息类
class _IsolateMessage {
  final SendPort sendPort;
  final int iterations;
  final int maxNumber;

  _IsolateMessage({
    required this.sendPort,
    required this.iterations,
    required this.maxNumber,
  });
}

// 进度消息
class _ProgressMessage {
  final int iteration;
  final double progress;
  final int primeCount;

  _ProgressMessage({
    required this.iteration,
    required this.progress,
    required this.primeCount,
  });
}

// 结果消息
class _ResultMessage {} 