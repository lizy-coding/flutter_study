# Flutter 弹窗学习（pop_widget）

本工程基于 Flutter 默认模板，改造成了“弹窗学习”示例工程，集中展示常见弹窗组件与多种触发方式，便于学习与对照使用。

## 包含的弹窗与触发方式

- AlertDialog：点击列表项触发
- SimpleDialog：点击列表项右侧图标触发
- Modal Bottom Sheet：长按列表项触发
- Cupertino AlertDialog：双击列表项触发
- 自定义 Dialog：点击按钮触发
- 持久化 BottomSheet：点击右下角 FAB 显示/关闭
- DatePicker/TimePicker：通过 AppBar 右侧菜单触发
- AboutDialog：通过 AppBar 信息按钮或 Drawer 菜单触发
- Context Menu（showMenu）：点击列表项在手指位置弹出菜单
- 退出确认弹窗：返回键触发（`WillPopScope`）

## 运行

1. 安装依赖：`flutter pub get`
2. 运行：`flutter run`

进入应用后，按列表说明操作即可查看相应弹窗效果。
