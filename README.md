# Flutter 学习项目集合

本项目是一个统一的 Flutter 学习仓库，所有示例模块位于 `lib/` 目录下，通过路由切换进入不同模块。涵盖网络、异步、UI 动效、状态管理等常见场景。

## 支持平台

- macOS
- Windows
- 移动端（iOS / Android）

## 环境与快速开始

- Flutter 3.x / Dart 3.x
- 根目录执行：
  ```bash
  flutter pub get
  flutter run [-d <device>]
  ```
- 代码检查与格式化：
  ```bash
  flutter analyze
  dart format .
  ```

## 项目结构

```
lib/
├── main.dart              # 入口
├── app.dart               # 应用主壳
├── router/                # 路由配置
├── adsorption_line/       # 智能吸附线画板
├── debounce_throttle/     # 防抖与节流
├── download_animation_demo/ # 下载飞入动效
├── flutter_ioc/           # IoC 容器示例
├── interceptor_test/      # Dio 拦截器链路 + Mock Server
├── isolate_stream_demo/   # Isolate 任务管理器
├── isolate_test/          # 主线程 vs Isolate 对比
├── microtask/             # 事件循环演示
├── pop_widget/            # 弹窗合集
├── scroll_table/          # 二维滚动表格
├── status_manage/         # 状态管理演进
├── stream_subscription/   # Stream 示例
└── tree_state/            # 三棵树与生命周期
```

## 示例索引（按主题）

### UI 与动效
- `adsorption_line`：智能吸附线画板，矩形/圆形/线条创建与拖拽，对齐辅助线、工具栏和快捷键。
- `download_animation_demo`：下载飞入动效三种实现（自定义 View / CustomPaint / Overlay），带参数调节面板。
- `pop_widget`：常见弹窗合集，包含顺序链式 Overlay 演示与多种触发方式。
- `scroll_table`：二维滚动表格，固定表头/行头，基于 `two_dimensional_scrollables`。
- `tree_state`：Widget/Element/RenderObject 三棵树与生命周期、CustomPainter、RepaintBoundary 重绘范围示例。

### 异步与并发
- `debounce_throttle`：防抖与节流执行时序对比。
- `isolate_test`：主线程 vs Isolate 执行耗时计算的 UI 流畅度对比。
- `isolate_stream_demo`：多任务 Isolate 管理器，支持进度上报、暂停/恢复/停止。
- `microtask`：事件循环演示，微任务队列与事件队列的执行顺序可视化。
- `stream_subscription`：单订阅/广播流示例，包含暂停/恢复/取消与变换工具。

### 架构与状态
- `status_manage`：状态管理演进链路，串联 setState、Provider、Riverpod、Bloc，附时间轴动画与测试用例。
- `flutter_ioc`：Provider + 自研 IoC 容器示例，支持注册/作用域/属性注入，含 `test/ioc_container_test.dart`。

### 网络与平台
- `interceptor_test`：Dio 拦截器链路（Auth/Error/Retry/Log）+ 内置本地 Mock Server，覆盖登录/列表/Token 刷新。
- `usb_detector_demo`：跨平台 USB 设备检测，周期扫描与手动刷新，使用 Stream 推送设备与状态消息。
