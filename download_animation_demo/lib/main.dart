import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Download Animation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DownloadAnimationPage(),
    );
  }
}

class DownloadAnimationPage extends StatefulWidget {
  const DownloadAnimationPage({super.key});

  @override
  State<DownloadAnimationPage> createState() => _DownloadAnimationPageState();
}

class _DownloadAnimationPageState extends State<DownloadAnimationPage>
    with TickerProviderStateMixin {
  List<DownloadItem> downloadItems = [];
  late AnimationController _animationController;
  
  final GlobalKey _downloadAreaKey = GlobalKey();
  Offset? _downloadAreaPosition;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
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
      duration: const Duration(milliseconds: 1500),
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
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildFileList(),
              const SizedBox(height: 40),
              _buildDownloadArea(),
            ],
          ),
          ...downloadItems.map((item) => _buildFlyingItem(item)).toList(),
        ],
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
          left: position.dx - 30,
          top: position.dy - 30,
          child: Transform.scale(
            scale: math.max(0.1, 1.0 - scale),
            child: Opacity(
              opacity: math.max(0.0, opacity),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade300,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.file_download, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '下载',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DownloadItem {
  final String id;
  final String fileName;
  final String fileSize;
  final Offset startPosition;
  final Offset endPosition;
  
  Animation<Offset>? positionAnimation;
  Animation<double>? scaleAnimation;
  Animation<double>? opacityAnimation;
  AnimationController? animationController;

  DownloadItem({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.startPosition,
    required this.endPosition,
  });
}