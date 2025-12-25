import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import '../models/download_item.dart';
import '../models/animation_config.dart';

/// 下载动画页面组件
class DownloadAnimationPage extends StatefulWidget {
  final AnimationConfig? animationConfig;

  const DownloadAnimationPage({super.key, this.animationConfig});

  @override
  State<DownloadAnimationPage> createState() => _DownloadAnimationPageState();
}

class _DownloadAnimationPageState extends State<DownloadAnimationPage>
    with TickerProviderStateMixin {
  List<DownloadItem> downloadItems = [];
  late AnimationController _animationController;

  final GlobalKey _downloadAreaKey = GlobalKey();
  Offset? _downloadAreaPosition;

  // 使用AnimationConfig类管理动画参数
  late AnimationConfig animationConfig;

  // 控制是否显示参数控制面板
  bool showControlPanel = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // 初始化动画配置 - 优先使用父组件传入的配置
    animationConfig = widget.animationConfig ?? const AnimationConfig();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDownloadAreaPosition();
    });
  }

  void _getDownloadAreaPosition() {
    final RenderBox? renderBox = 
        _downloadAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      setState(() {
        _downloadAreaPosition = position + Offset(renderBox.size.width / 2, renderBox.size.height / 2);
      });
    }
  }

  void _startDownload(String fileName, String fileSize, Offset startPosition) {
    final downloadItem = DownloadItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fileName: fileName,
      fileSize: fileSize,
      startPosition: startPosition,
      endPosition: _downloadAreaPosition ?? const Offset(200, 600),
    );

    setState(() {
      downloadItems.add(downloadItem);
    });

    _animateDownload(downloadItem);
  }

  void _animateDownload(DownloadItem item) {
    final animationController = AnimationController(
      duration: Duration(milliseconds: (animationConfig.animationDuration / animationConfig.flyingSpeed).round()),
      vsync: this,
    );

    final curveAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    final positionAnimation = Tween<Offset>(
      begin: item.startPosition,
      end: item.endPosition,
    ).animate(curveAnimation);

    final scaleAnimation = Tween<double>(
      begin: 1.2,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
    ));

    final opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
    ));

    item.positionAnimation = positionAnimation;
    item.scaleAnimation = scaleAnimation;
    item.opacityAnimation = opacityAnimation;
    item.animationController = animationController;

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          downloadItems.removeWhere((element) => element.id == item.id);
        });
        animationController.dispose();

        HapticFeedback.lightImpact();
        _showDownloadComplete(item);
      }
    });

    animationController.forward();
  }

  void _showDownloadComplete(DownloadItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.fileName} 下载完成'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var item in downloadItems) {
      item.animationController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('下载飞入动画'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(showControlPanel ? Icons.close : Icons.settings),
            onPressed: () {
              setState(() {
                showControlPanel = !showControlPanel;
              });
            },
            tooltip: '动画设置',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (showControlPanel) _buildControlPanel(),
              _buildFileList(),
              const SizedBox(height: 40),
              _buildDownloadArea(),
            ],
          ),
          ...downloadItems.map((item) => _buildFlyingItem(item)),
        ],
      ),
    );
  }

  /// 构建动画参数控制面板
  Widget _buildControlPanel() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '动画参数设置',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),

            // 动画持续时间滑块
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('动画持续时间: ${animationConfig.animationDuration} 毫秒'),
                Slider(
                  value: animationConfig.animationDuration.toDouble(),
                  min: 500,
                  max: 3000,
                  divisions: 25,
                  onChanged: (value) {
                    setState(() {
                      animationConfig = animationConfig.copyWith(
                        animationDuration: value.toInt(),
                      );
                    });
                  },
                ),
              ],
            ),

            // 飞入点偏移量滑块
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('飞入点大小偏移: ${animationConfig.flyingItemOffset.toInt()}'),
                Slider(
                  value: animationConfig.flyingItemOffset,
                  min: 10,
                  max: 50,
                  divisions: 40,
                  onChanged: (value) {
                    setState(() {
                      animationConfig = animationConfig.copyWith(
                        flyingItemOffset: value,
                      );
                    });
                  },
                ),
              ],
            ),

            // 飞入点内边距滑块
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('飞入点内边距: ${animationConfig.flyingItemPadding.toInt()}'),
                Slider(
                  value: animationConfig.flyingItemPadding,
                  min: 4,
                  max: 16,
                  divisions: 12,
                  onChanged: (value) {
                    setState(() {
                      animationConfig = animationConfig.copyWith(
                        flyingItemPadding: value,
                      );
                    });
                  },
                ),
              ],
            ),

            // 飞入点圆角滑块
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('飞入点圆角: ${animationConfig.flyingItemRadius.toInt()}'),
                Slider(
                  value: animationConfig.flyingItemRadius,
                  min: 4,
                  max: 16,
                  divisions: 12,
                  onChanged: (value) {
                    setState(() {
                      animationConfig = animationConfig.copyWith(
                        flyingItemRadius: value,
                      );
                    });
                  },
                ),
              ],
            ),

            // 飞入速度滑块
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('飞入速度: ${animationConfig.flyingSpeed.toStringAsFixed(1)}x'),
                Slider(
                  value: animationConfig.flyingSpeed,
                  min: 0.5,
                  max: 3.0,
                  divisions: 25,
                  onChanged: (value) {
                    setState(() {
                      animationConfig = animationConfig.copyWith(
                        flyingSpeed: value,
                      );
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList() {
    final files = [
      {'name': 'Flutter开发指南.pdf', 'size': '15.2 MB', 'icon': Icons.picture_as_pdf},
      {'name': '项目源码.zip', 'size': '89.5 MB', 'icon': Icons.folder_zip},
      {'name': '设计稿.psd', 'size': '234.7 MB', 'icon': Icons.image},
      {'name': '演示视频.mp4', 'size': '156.3 MB', 'icon': Icons.video_file},
      {'name': '技术文档.docx', 'size': '3.8 MB', 'icon': Icons.description},
      {'name': '音频文件.mp3', 'size': '12.4 MB', 'icon': Icons.audiotrack},
    ];

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  file['icon'] as IconData,
                  color: Colors.blue.shade600,
                  size: 28,
                ),
              ),
              title: Text(
                file['name'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                file['size'] as String,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTapDown: (TapDownDetails details) {
                      // 直接使用点击位置作为动画起始点
                      final itemPosition = details.globalPosition;

                      _startDownload(
                        file['name'] as String,
                        file['size'] as String,
                        itemPosition,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '下载',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDownloadArea() {
    return Container(
      key: _downloadAreaKey,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.download_done,
              size: 40,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '下载中心',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击文件右侧下载按钮查看飞入效果',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlyingItem(DownloadItem item) {
    return AnimatedBuilder(
      animation: item.animationController!,
      builder: (context, child) {
        final position = item.positionAnimation!.value;
        final scale = item.scaleAnimation!.value;
        final opacity = item.opacityAnimation!.value;

        return Positioned(
          left: position.dx - animationConfig.flyingItemOffset,
          top: position.dy - animationConfig.flyingItemOffset,
          child: Transform.scale(
            scale: math.max(0.1, 1.0 - scale),
            child: Opacity(
              opacity: math.max(0.0, opacity),
              child: Container(
                padding: EdgeInsets.all(animationConfig.flyingItemPadding + 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(animationConfig.flyingItemRadius + 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade300,
                      blurRadius: 12,
                      spreadRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Colors.blue.shade600.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/icons/paper_plane.svg',
                  width: 32,
                  height: 32,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}