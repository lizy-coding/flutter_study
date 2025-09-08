import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/download_item.dart';
import '../models/animation_config.dart';
import '../services/overlay_download_service.dart';
import 'dart:math' as math;

/// 下载动画对比页面
class DownloadComparisonPage extends StatefulWidget {
  const DownloadComparisonPage({super.key});

  @override
  State<DownloadComparisonPage> createState() => _DownloadComparisonPageState();
}

class _DownloadComparisonPageState extends State<DownloadComparisonPage>
    with TickerProviderStateMixin {
  List<DownloadItem> downloadItems = [];
  final OverlayDownloadService _overlayService = OverlayDownloadService();
  
  final GlobalKey _downloadAreaKey = GlobalKey();
  Offset? _downloadAreaPosition;
  
  late AnimationConfig animationConfig;
  bool showControlPanel = false;
  
  @override
  void initState() {
    super.initState();
    animationConfig = const AnimationConfig();
    
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
  
  /// 使用自定义 View 方式开始下载
  void _startCustomViewDownload(String fileName, String fileSize, Offset startPosition) {
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
    
    _animateCustomViewDownload(downloadItem);
  }
  
  /// 使用 Overlay 方式开始下载
  void _startOverlayDownload(String fileName, String fileSize, Offset startPosition) {
    if (_downloadAreaPosition == null) return;
    
    _overlayService.startDownload(
      context: context,
      fileName: fileName,
      fileSize: fileSize,
      startPosition: startPosition,
      endPosition: _downloadAreaPosition!,
      animationConfig: animationConfig,
      onComplete: () {
        _showDownloadComplete(fileName, 'Overlay');
      },
    );
  }
  
  void _animateCustomViewDownload(DownloadItem item) {
    final animationController = AnimationController(
      duration: Duration(milliseconds: animationConfig.animationDuration),
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
      begin: 1.0,
      end: 0.0,
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
        _showDownloadComplete(item.fileName, 'Custom View');
      }
    });
    
    animationController.forward();
  }
  
  void _showDownloadComplete(String fileName, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$fileName 下载完成 ($type)'),
        duration: const Duration(seconds: 2),
        backgroundColor: type == 'Overlay' ? Colors.green : Colors.blue,
      ),
    );
  }
  
  @override
  void dispose() {
    for (var item in downloadItems) {
      item.animationController?.dispose();
    }
    _overlayService.clearAll();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('下载动画对比'),
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
              _buildComparisonInfo(),
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
  
  /// 构建对比说明
  Widget _buildComparisonInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '实现方式对比',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildComparisonCard(
                  title: 'Custom View',
                  color: Colors.blue,
                  description: '基于 Stack 的自定义视图实现\n受视图层级限制',
                  icon: Icons.layers,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildComparisonCard(
                  title: 'Overlay',
                  color: Colors.green,
                  description: '基于 Overlay 的全局实现\n不受视图层级限制',
                  icon: Icons.open_in_full,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildComparisonCard({
    required String title,
    required Color color,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Custom View 下载按钮
                  Container(
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
                          _startCustomViewDownload(
                            file['name'] as String,
                            file['size'] as String,
                            details.globalPosition,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.download, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'View',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Overlay 下载按钮
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTapDown: (TapDownDetails details) {
                          _startOverlayDownload(
                            file['name'] as String,
                            file['size'] as String,
                            details.globalPosition,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.cloud_download, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Overlay',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
        border: Border.all(color: Colors.purple.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade100,
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
              color: Colors.purple.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.download_done,
              size: 40,
              color: Colors.purple.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '下载中心',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击不同按钮体验两种实现方式',
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
                padding: EdgeInsets.all(animationConfig.flyingItemPadding),
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(animationConfig.flyingItemRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade300,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/icons/paper_plane.svg',
                  width: 24,
                  height: 24,
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