# Flutter 学习项目集合

当前目录下每个示例都可单独运行，涵盖网络、异步、UI 动效、状态管理等常见场景。

## 快速开始
- 安装 Flutter SDK 并准备可用设备或模拟器。
- 进入任一子目录后执行：
  - `flutter pub get` 拉取依赖
  - `flutter run` 运行示例（可加 `-d` 指定设备）
  - `flutter analyze`、`flutter test`、`dart format .` 进行代码检查与格式化

## 示例索引
- `adsorption_line`：智能吸附线画板，支持矩形/圆形/线条创建与拖拽，对齐辅助线、工具栏和快捷键操作。
- `debounce_throttle`：防抖（debounce）与节流（throttle）机制对比演示。
- `download_animation_demo`：下载进度动画效果演示。
- `flutter_ioc`：依赖注入（IoC）模式实现的计算器，演示控制反转设计。
- `interceptor_test`：HTTP 拦截器模型演示，包含认证、错误处理、日志记录和重试机制。
- `isolate_stream_demo`：基于 Isolate 与 Stream 的任务管理器，展示异步任务处理和数据流管理。
- `isolate_test`：对比主线程与 Isolate 执行耗时计算的 UI 响应差异，演示跨 Isolate 通信与性能提升。
- `microtask`：Dart 事件循环中 Microtask 队列与 Event 队列运行机制演示。
- `pop_widget`：弹窗组件与触发方式合集，涵盖 AlertDialog、SimpleDialog、Modal Bottom Sheet、Cupertino 弹窗、自定义对话框与链式 Overlay 顺序控制。
- `scroll_table`：二维滚动表格演示，支持横纵滚动、固定行列头、自定义单元格样式与响应式布局。
- `status_manage`：状态管理演进示例，串联 setState、Provider、Riverpod、Bloc 等模式的通知链路与重建日志。
- `stream_subscription`：Stream 订阅与广播流（Broadcast Stream）功能演示。
- `tree_state`：Flutter 三棵树与生命周期示例，包含 Stateless/Stateful 重建对比、State 生命周期、CustomPainter 与 RepaintBoundary 重绘范围演示。
- `usb_detector_demo`：跨平台 USB 设备检测功能演示，支持 Windows/macOS/Linux。


