import 'utils/debounce_throttle.dart' show Debouncer, Throttle;
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 场景选择器
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPageIndex == 0 
                        ? Theme.of(context).colorScheme.primaryContainer 
                        : null,
                    ),
                    onPressed: () {
                      setState(() => _currentPageIndex = 0);
                      _pageController.animateToPage(
                        0, 
                        duration: const Duration(milliseconds: 300), 
                        curve: Curves.easeInOut
                      );
                    },
                    child: const Text('按钮点击场景'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPageIndex == 1 
                        ? Theme.of(context).colorScheme.primaryContainer 
                        : null,
                    ),
                    onPressed: () {
                      setState(() => _currentPageIndex = 1);
                      _pageController.animateToPage(
                        1, 
                        duration: const Duration(milliseconds: 300), 
                        curve: Curves.easeInOut
                      );
                    },
                    child: const Text('滚动场景'),
                  ),
                ),
              ],
            ),
          ),
          
          // 防抖节流描述
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                const Text(
                  '防抖(Debounce)：在一段时间内多次触发事件，只执行最后一次。',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 8),
                const Text(
                  '节流(Throttle)：在一段时间内多次触发事件，只执行第一次。',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
          ),
          
          // 场景内容
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPageIndex = index);
              },
              children: const [
                ButtonScene(),
                ScrollScene(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonScene extends StatefulWidget {
  const ButtonScene({super.key});

  @override
  State<ButtonScene> createState() => _ButtonSceneState();
}

class _ButtonSceneState extends State<ButtonScene> with TickerProviderStateMixin {
  int _debounceCount = 0;
  int _throttleCount = 0;
  int _normalCount = 0;
  
  // 普通事件、防抖事件和节流事件的处理次数
  List<int> _normalEvents = [];
  List<int> _debounceEvents = [];
  List<int> _throttleEvents = [];
  
  // 用于展示事件触发的动画控制器
  late AnimationController _normalAnim;
  late AnimationController _debounceAnim;
  late AnimationController _throttleAnim;
  
  // 防抖和节流实例
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  final Throttle _throttler = Throttle(limit: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    _normalAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _debounceAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _throttleAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _normalAnim.dispose();
    _debounceAnim.dispose();
    _throttleAnim.dispose();
    super.dispose();
  }

  // 添加事件记录
  void _addEventRecord(List<int> list, int count) {
    setState(() {
      list.add(count);
      if (list.length > 10) {
        list.removeAt(0);
      }
    });
  }

  // 处理普通点击
  void _handleNormalClick() {
    setState(() => _normalCount++);
    _normalAnim.forward(from: 0);
    _addEventRecord(_normalEvents, _normalCount);
  }

  // 处理防抖点击
  void _handleDebounceClick() {
    _debounceAnim.forward(from: 0);
    _debouncer.run(() {
      setState(() => _debounceCount++);
      _addEventRecord(_debounceEvents, _debounceCount);
    });
  }

  // 处理节流点击
  void _handleThrottleClick() {
    _throttleAnim.forward(from: 0);
    _throttler.run(() {
      setState(() => _throttleCount++);
      _addEventRecord(_throttleEvents, _throttleCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '连续快速点击按钮，对比不同处理方式:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // 按钮区域
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAnimatedButton(
                '普通点击',
                Colors.grey,
                _handleNormalClick,
                _normalAnim,
              ),
              _buildAnimatedButton(
                '防抖点击',
                Colors.red,
                _handleDebounceClick,
                _debounceAnim,
              ),
              _buildAnimatedButton(
                '节流点击',
                Colors.blue,
                _handleThrottleClick,
                _throttleAnim,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 计数器显示
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCounter('普通:', _normalCount, Colors.grey),
              _buildCounter('防抖:', _debounceCount, Colors.red),
              _buildCounter('节流:', _throttleCount, Colors.blue),
            ],
          ),
          
          const SizedBox(height: 30),
          const Text('事件触发可视化:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          // 事件触发可视化区域
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEventVisualization('普通', _normalEvents, Colors.grey),
                _buildEventVisualization('防抖', _debounceEvents, Colors.red),
                _buildEventVisualization('节流', _throttleEvents, Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 创建带动画的按钮
  Widget _buildAnimatedButton(
    String text, 
    Color color, 
    VoidCallback onTap, 
    AnimationController anim
  ) {
    return Column(
      children: [
        ScaleTransition(
          scale: CurvedAnimation(
            parent: anim,
            curve: Curves.elasticOut,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color.withOpacity(0.2),
              foregroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              anim.forward(from: 0.0);  // 添加按钮点击动画触发
              onTap();                  // 触发点击回调
            },
            child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // 创建计数器显示
  Widget _buildCounter(String prefix, int count, Color color) {
    return Column(
      children: [
        Text(
          '$prefix $count',
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: color,
          ),
        ),
      ],
    );
  }

  // 创建事件触发可视化组件
  Widget _buildEventVisualization(String title, List<int> events, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final timestamp = events[index];
                  return Container(
                    // 添加时间戳格式化显示
                    child: Text('${DateTime.fromMillisecondsSinceEpoch(timestamp).toString().substring(11, 19)}',
                      style: TextStyle(color: color.withOpacity(0.8))
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollScene extends StatefulWidget {
  const ScrollScene({super.key});

  @override
  State<ScrollScene> createState() => _ScrollSceneState();
}

class _ScrollSceneState extends State<ScrollScene> with SingleTickerProviderStateMixin {
  double _scrollPosition = 0;
  double _debouncePosition = 0;
  double _throttlePosition = 0;
  
  final ScrollController _scrollController = ScrollController();
  late AnimationController _positionAnimController;
  
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  final Throttle _throttler = Throttle(limit: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    _positionAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // 滚动监听
    _scrollController.addListener(() {
      setState(() => _scrollPosition = _scrollController.offset);
      
      // 防抖处理滚动位置
      _debouncer.run(() {
        setState(() => _debouncePosition = _scrollController.offset);
        _positionAnimController.forward(from: 0);
      });
      
      // 节流处理滚动位置
      _throttler.run(() {
        setState(() => _throttlePosition = _scrollController.offset);
        _positionAnimController.forward(from: 0);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _positionAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 滚动位置指示器
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[200],
          child: Column(
            children: [
              _buildPositionIndicator('实时位置', _scrollPosition, Colors.grey[800]!),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildAnimatedPositionIndicator(
                      '防抖位置', 
                      _debouncePosition, 
                      Colors.red
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildAnimatedPositionIndicator(
                      '节流位置', 
                      _throttlePosition, 
                      Colors.blue
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // 可滚动列表
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: 100,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '列表项 #$index',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildPositionVisualization(index),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 创建位置指示器
  Widget _buildPositionIndicator(String title, double position, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[300],
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (position / (_scrollController.hasClients ? _scrollController.position.maxScrollExtent : 1)).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: color,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            '${position.toStringAsFixed(0)}px',
            textAlign: TextAlign.right,
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }

  // 创建带动画的位置指示器
  Widget _buildAnimatedPositionIndicator(String title, double position, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey[300],
                ),
              ),
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _positionAnimController,
                  curve: Curves.easeOut,
                ),
                child: Container(
                  height: 12,
                  width: (position / (_scrollController.hasClients ? _scrollController.position.maxScrollExtent : 1)) * MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            '${position.toStringAsFixed(0)}px',
            textAlign: TextAlign.right,
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }

  // 为列表项创建位置可视化
  Widget _buildPositionVisualization(int index) {
    final double itemPosition = index * 100.0; // 模拟列表项位置
    final bool isNearReal = (_scrollPosition - itemPosition).abs() < 200;
    final bool isNearDebounce = (_debouncePosition - itemPosition).abs() < 200;
    final bool isNearThrottle = (_throttlePosition - itemPosition).abs() < 200;
    
    return Row(
      children: [
        _buildPositionDot('实时', isNearReal, Colors.grey[800]!),
        _buildPositionDot('防抖', isNearDebounce, Colors.red),
        _buildPositionDot('节流', isNearThrottle, Colors.blue),
      ],
    );
  }

  // 创建位置指示点
  Widget _buildPositionDot(String label, bool isActive, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? color : Colors.transparent,
              border: Border.all(color: color),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
