# Flutter Tree & Lifecycle Demo

一个用于观察 Widget / Element / RenderObject 三棵树关系、StatefulWidget 生命周期、以及绘制与重绘流程的示例项目。

## 项目结构

- `lib/main.dart`：入口，注册路由并设置主页 `DemoHomePage`。
- `lib/routes.dart`：统一的路由常量，避免字符串分散。
- `lib/pages/demo_home_page.dart`：展示所有示例入口。
- `lib/pages/basic_widgets_page.dart`：Stateless vs Stateful 重建行为示例。
- `lib/pages/state_lifecycle_page.dart`：StatefulWidget 生命周期与 push/pop 行为示例。
- `lib/pages/painter_demo_page.dart`：CustomPainter 的 build/layout/paint 分离示例。
- `lib/pages/repaint_boundary_demo_page.dart`：RepaintBoundary 对重绘范围的影响示例。

## 各页面与类的运行/阶段说明

**Basic Widgets Demo**
- `BasicWidgetsPage`：`setState` 改变 `_counter`，父组件 `build` 会打印日志。
- `StatelessBox`：只有 `build` 日志；父组件 rebuild 时它也会随之重建。
- `StatefulBox`：`initState` / `build` / `dispose` 日志；父组件重建时复用同一个 State，观察是否触发 `build`。

**State Lifecycle Demo**
- `StateLifecyclePage`：完整生命周期回调日志（`initState`、`didChangeDependencies`、`didUpdateWidget`、`deactivate`、`dispose`）；`setState` 后打印计数。
- `LifecycleChildPage`：被 push/pop 时可观察父页面的 `deactivate`/`dispose` 是否触发。

**Painter Demo**
- `PainterDemoPage`：滑动 Slider 调整半径，触发 `setState`，打印父级 `build` 日志。
- `PainterDemoPainter`：`shouldRepaint` 判断旧新半径；`paint` 打印当前尺寸/半径。可对比 build 阶段和绘制阶段的调用时机。

**RepaintBoundary Demo**
- `RepaintBoundaryDemoPage`：点击按钮只改变右侧颜色，观察有/无 RepaintBoundary 时的重绘范围。
- `NoBoundaryPainter`：`shouldRepaint` 恒为 false，只在首次布局时 `paint`。
- `BoundaryPainter`：颜色变化触发 `shouldRepaint` 与 `paint`，配合 RepaintBoundary 只重绘右侧。

## 学习/操作路径（建议配合控制台日志）

1) `flutter run` 启动应用，保持控制台输出可见。  
2) 打开 **Basic Widgets Demo**：点击悬浮按钮，观察父级和子组件的 `build` 日志差异。  
3) 打开 **State Lifecycle Demo**：  
   - 点击 `setState +1` 看 `build` 与计数变化；  
   - 点击 “Push & Pop 页面”，在 push/pop 时留意 `deactivate`、`dispose` 顺序。  
4) 打开 **Painter Demo**：拖动 Slider，对比 `shouldRepaint` 与 `paint` 调用次数与参数。  
5) 打开 **RepaintBoundary Demo**：点击按钮改变右侧颜色，观察左右两侧 `paint` 日志差异，理解 RenderObject 树的分叉点。

提示：`debugPrint` 已埋点在关键阶段，按上述步骤操作即可把 UI 事件与框架回调对应起来。
