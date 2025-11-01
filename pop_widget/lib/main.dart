import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 弹窗学习',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PopDemoHomePage(title: 'Flutter 弹窗学习'),
    );
  }
}

class PopDemoHomePage extends StatefulWidget {
  const PopDemoHomePage({super.key, required this.title});

  final String title;

  @override
  State<PopDemoHomePage> createState() => _PopDemoHomePageState();
}

class _PopDemoHomePageState extends State<PopDemoHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _bottomSheetController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _showExitConfirmDialog(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              tooltip: '显示 AboutDialog',
              onPressed: _showAbout,
              icon: const Icon(Icons.info_outline),
            ),
            PopupMenuButton<String>(
              tooltip: '选择更多弹窗',
              onSelected: (value) async {
                switch (value) {
                  case 'date':
                    await _showDatePicker();
                    break;
                  case 'time':
                    await _showTimePicker();
                    break;
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'date', child: Text('日期选择弹窗')),
                PopupMenuItem(value: 'time', child: Text('时间选择弹窗')),
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.deepPurple),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('弹窗演示菜单',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('显示 AboutDialog'),
                onTap: () {
                  Navigator.pop(context);
                  _showAbout();
                },
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: const Text('AlertDialog (普通对话框)'),
              subtitle: const Text('点击触发'),
              onTap: () => _showAlertDialog(),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('SimpleDialog (选项对话框)'),
              subtitle: const Text('点击右侧图标触发'),
              trailing: IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: _showSimpleDialog,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.keyboard_double_arrow_up),
              title: const Text('Modal Bottom Sheet (模态底部弹窗)'),
              subtitle: const Text('长按触发'),
              onLongPress: _showModalBottomSheet,
            ),
            const Divider(height: 16),
            _CupertinoDoubleTapTile(onDoubleTap: _showCupertinoAlert),
            ListTile(
              leading: const Icon(Icons.design_services),
              title: const Text('自定义 Dialog'),
              subtitle: const Text('点击按钮触发'),
              trailing: ElevatedButton(
                onPressed: _showCustomDialog,
                child: const Text('打开'),
              ),
            ),
            _ContextMenuTile(onShowMenu: _showContextMenu),
            const SizedBox(height: 80),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _togglePersistentBottomSheet,
          icon: const Icon(Icons.vertical_align_top),
          label:
              Text(_bottomSheetController == null ? '显示底部工具条' : '关闭底部工具条'),
        ),
      ),
    );
  }

  // 1) AlertDialog
  Future<void> _showAlertDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('这是一个 AlertDialog 示例。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: const Text('确定')),
        ],
      ),
    );
  }

  // 2) SimpleDialog
  Future<void> _showSimpleDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('选择一个选项'),
        children: [
          SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'A'),
              child: const Text('选项 A')),
          SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'B'),
              child: const Text('选项 B')),
          SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'C'),
              child: const Text('选项 C')),
        ],
      ),
    );
    if (!mounted) return;
    if (result != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('选择了: $result')));
    }
  }

  // 3) Modal Bottom Sheet
  Future<void> _showModalBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('这是一个模态底部弹窗',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check),
                    label: const Text('确定'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('关闭'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 4) Cupertino 风格对话框（双击触发）
  Future<void> _showCupertinoAlert() async {
    await showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('iOS 风格弹窗'),
        content: const Text('通过双击手势触发。'),
        actions: [
          CupertinoDialogAction(
              onPressed: () => Navigator.pop(context), child: const Text('好的')),
        ],
      ),
    );
  }

  // 5) 自定义 Dialog
  Future<void> _showCustomDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.palette, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  const Text('自定义内容',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close)),
                ],
              ),
              const Text('这里可以放置任意自定义 Widget，例如输入框、进度等。'),
              const SizedBox(height: 12),
              TextField(decoration: const InputDecoration(labelText: '输入一些内容')),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('提交'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 6) 持久化 BottomSheet（FAB 切换）
  void _togglePersistentBottomSheet() {
    if (_bottomSheetController != null) {
      _bottomSheetController!.close();
      _bottomSheetController = null;
      setState(() {});
      return;
    }
    _bottomSheetController =
        _scaffoldKey.currentState?.showBottomSheet((context) {
      return SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.tips_and_updates_outlined),
              const SizedBox(width: 8),
              const Expanded(child: Text('这是一个持久化底部工具条，你可以手动关闭。')),
              TextButton(
                  onPressed: () => _bottomSheetController?.close(),
                  child: const Text('关闭')),
            ],
          ),
        ),
      );
    });
    _bottomSheetController?.closed.whenComplete(() {
      if (mounted) setState(() => _bottomSheetController = null);
    });
    setState(() {});
  }

  // 7) 日期/时间选择
  Future<void> _showDatePicker() async {
    final now = DateTime.now();
    await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
  }

  Future<void> _showTimePicker() async {
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  // 8) About 对话框
  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Flutter 弹窗学习',
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(),
      children: const [Text('展示多种弹窗类型与触发方式。')],
    );
  }

  // 9) 退出确认弹窗（返回键触发）
  Future<bool?> _showExitConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出应用吗？'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('退出')),
        ],
      ),
    );
  }

  // 10) 上下文菜单（在点击位置弹出）
  Future<void> _showContextMenu(TapDownDetails details) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem(value: 'edit', child: Text('编辑')),
        PopupMenuItem(value: 'share', child: Text('分享')),
        PopupMenuItem(value: 'delete', child: Text('删除')),
      ],
    );
    if (!mounted) return;
    if (selected != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('选择了: $selected')));
    }
  }
}

// 专用条目：双击触发 Cupertino 对话框
class _CupertinoDoubleTapTile extends StatelessWidget {
  const _CupertinoDoubleTapTile({required this.onDoubleTap});
  final VoidCallback onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: const ListTile(
        leading: Icon(Icons.phone_iphone),
        title: Text('Cupertino AlertDialog (iOS 风格)'),
        subtitle: Text('双击触发'),
      ),
    );
  }
}

// 专用条目：在点击处弹出上下文菜单
class _ContextMenuTile extends StatelessWidget {
  const _ContextMenuTile({required this.onShowMenu});
  final Future<void> Function(TapDownDetails) onShowMenu;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: onShowMenu,
      child: const ListTile(
        leading: Icon(Icons.more_vert),
        title: Text('Context Menu (showMenu)'),
        subtitle: Text('轻触显示菜单（在手指位置）'),
      ),
    );
  }
}

