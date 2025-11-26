你是一个资深 Flutter 工程师和教学示例构建助手。  
请为我生成一个 **完整可运行的 Flutter 学习 Demo**（只需要 `lib/main.dart`），用于帮助理解 Flutter 的：

- 三棵树：Widget / Element / RenderObject
- 生命周期：尤其是 StatefulWidget 的 initState / build / didUpdateWidget / dispose
- 渲染差异：build / layout / paint 的触发差异和次数
- 局部重绘：RepaintBoundary 等

我会把你生成的代码直接复制到 `lib/main.dart` 中运行，请确保代码完整、可编译、可直接运行。

---

## 全局要求

- 使用 Flutter 3.x / Dart 空安全（null-safety）。
- 使用 `MaterialApp` 作为入口。
- `main()` 中配置：`runApp(MyApp());`
- `MyApp` 内部使用 `MaterialApp`，`home` 为一个路由菜单页面 `DemoHomePage`。
- 使用多路由（多个页面）来演示不同场景，并且通过 `debugPrint` 输出关键生命周期和渲染日志。

日志要求：

- 所有关键生命周期和渲染调用请使用 `debugPrint()`，日志前缀标出页面或组件名，方便在控制台过滤。
  - 示例：`debugPrint('[BasicWidgetsPage] build');`
  - 示例：`debugPrint('[StateLifecyclePage] initState');`
  - 示例：`debugPrint('[PainterDemo] paint, radius=$radius');`
- 尽量在不同阶段打印日志：
  - StatelessWidget：`build`
  - StatefulWidget：`initState / didChangeDependencies / build / didUpdateWidget / deactivate / dispose`
  - CustomPainter：`paint / shouldRepaint`

代码风格要求：

- 类名有语义：如 `BasicWidgetsPage`、`StateLifecyclePage`、`PainterDemoPage`、`RepaintBoundaryDemoPage`。
- 合理拆分 Widget，代码结构清晰，注释简明。
- 每个页面顶部有一个明显的标题（如 `Text('State Lifecycle Demo')`）说明当前示例要观察的点。
- 不要使用第三方依赖，只用 Flutter SDK 自带内容。

---

## 路由 / 页面设计

### 1. 首页：路由菜单页面 `DemoHomePage`

功能：

- 使用 `Scaffold` + `AppBar`。
- `body` 使用 `ListView` 或 `Column`，列出若干 `ListTile` 或 `ElevatedButton`。
- 每个条目点击后跳转到对应示例页面。
- 至少包括以下四个路由：
  - `/basic_widgets`           → 基本 Stateless/Stateful 对比
  - `/state_lifecycle`         → Stateful 生命周期 & setState 行为
  - `/painter_demo`            → CustomPainter & RenderObject 绘制流程
  - `/repaint_boundary_demo`   → RepaintBoundary 局部重绘对比

路由配置方式：

- 可以使用 `routes: { ... }` 或 `onGenerateRoute`，任选其一，但要结构清晰。

---

### 2. 页面一：基础 Widgets 对比页 `/basic_widgets`

目的：对比 StatelessWidget 和 StatefulWidget 在多次 rebuild 下的行为差异。

要求：

- 页面类名：`BasicWidgetsPage`。
- 使用 `Scaffold` + `AppBar(title: Text('Basic Widgets Demo'))`。
- `body` 区分两块区域：
  - 左侧/上方：展示一个简单的 `StatelessWidget` 子组件，如 `StatelessBox`。
  - 右侧/下方：展示一个 `StatefulWidget` 子组件，如 `StatefulBox`。
- 页面中提供一个 `FloatingActionButton` 或按钮，每点击一次：
  - 使用 `setState` 更新父级中的一个计数器。
  - 把计数器通过构造参数传给两个子组件。
- 在以下位置打印日志：
  - 父页面 `BasicWidgetsPage` 的 `build`
  - `StatelessBox` 的 `build`
  - `StatefulBox` 的：
    - `initState`
    - `build`
    - `dispose`
- 通过多次点击按钮，可以在日志中明显看到：
  - Stateless 每次都只重建 build。
  - Stateful 只在第一次有 initState，之后只 build。
  - 页面被 pop 时，会触发 Stateful 的 dispose。

---

### 3. 页面二：State 生命周期 & setState 示例页 `/state_lifecycle`

目的：观察 StatefulWidget 生命周期完整调用顺序，以及 setState 的行为。

要求：

- 页面类名：`StateLifecyclePage`。
- 使用 `Scaffold` + `AppBar(title: Text('State Lifecycle Demo'))`。
- 定义一个 `StatefulWidget` 和其 `State`，在以下生命周期方法内打印日志：
  - `initState`
  - `didChangeDependencies`
  - `build`
  - `didUpdateWidget`
  - `deactivate`
  - `dispose`
- 页面 UI：
  - 显示当前内部计数器值。
  - 按钮 1：调用 `setState` 简单自增 `_counter`。
  - 按钮 2：`Navigator.push` 跳转到一个简单的新页面（比如仅显示一行文字），再返回。
- 目标效果：
  - 点击按钮 1：只看到当前 State 的 build 日志变化。
  - 点击按钮 2：可以在控制台观察当前 widget 在 push / pop 过程中的生命周期调用顺序（如 deactivate / reassemble / didChangeDependencies 等）。

---

### 4. 页面三：CustomPainter & 绘制流程示例页 `/painter_demo`

目的：观察 RenderObject / CustomPainter 的 paint 调用和 shouldRepaint 行为，理解绘制与 build 的区别。

要求：

- 页面类名：`PainterDemoPage`。
- 使用 `Scaffold` + `AppBar(title: Text('Painter Demo'))`。
- 页面中包含：
  - 一个 `Slider` 或 `Slider` + 文本，控制某个参数（如圆的半径、位置或颜色索引）。
  - 一个 `CustomPaint`，使用自定义 `CustomPainter` 绘制简单图形（例如：一个坐标系和一个圆）。
- `CustomPainter`：
  - 构造函数接收一个参数（如 `double radius`）。
  - 在 `paint(Canvas canvas, Size size)` 中：
    - 绘制参考背景（如十字坐标轴）。
    - 绘制一个圆或矩形，使用传入参数控制大小或位置。
    - 使用 `debugPrint('[PainterDemoPainter] paint, radius=$radius, size=$size');`
  - 在 `shouldRepaint` 中：
    - 比较旧参数与新参数，并打印日志：
      - `debugPrint('[PainterDemoPainter] shouldRepaint: old=$oldRadius, new=$radius');`
- 父 `PainterDemoPage` 的 `build` 中也使用 `debugPrint('[PainterDemoPage] build');`。
- 目标：
  - 拖动 Slider 时，可以在日志中区分：
    - 页面 build 的次数。
    - painter 的 paint / shouldRepaint 的调用次数和顺序。
  - 理解 Widget / Element 更新与 RenderObject / paint 的关系。

---

### 5. 页面四：RepaintBoundary 局部重绘对比页 `/repaint_boundary_demo`

目的：对比有无 RepaintBoundary 时，局部 UI 更新对整个树重绘的影响。

要求：

- 页面类名：`RepaintBoundaryDemoPage`。
- 使用 `Scaffold` + `AppBar(title: Text('RepaintBoundary Demo'))`。
- 页面中展示两个区域（上/下 或 左/右），都包含一个简单的自定义绘制组件：
  - 左侧区域：不使用 `RepaintBoundary` 包裹。
  - 右侧区域：外层使用 `RepaintBoundary` 包裹。
- 两个区域都可以使用一个简单的 `CustomPainter` 绘制不同颜色的方块或圆，并在 `paint` 中打印不同前缀的日志：
  - 如 `debugPrint('[NoBoundaryPainter] paint');`
  - 和 `debugPrint('[BoundaryPainter] paint');`
- 页面底部放置一个按钮，只改变右侧区域的状态（例如改变颜色索引/计数器）。
  - 改变右侧区域的状态时，使用 setState 触发重绘。
- 目标：
  - 通过日志观察：
    - 点击按钮时，右侧区域的 painter 一定会被调用。
    - 左侧区域的 painter 是否也被调用（预期：通过合理使用 RepaintBoundary，左侧不被影响）。
  - 用注释简单说明 RepaintBoundary 在 RenderObject 树中的作用。

---

## 三棵树相关注释与说明

在关键类和文件中使用简短注释，帮助理解三棵树关系：

- 在 `BasicWidgetsPage` 中说明：
  - Widget 是配置，每次 build 都会新建。
  - Element 关联 Widget，并管理 State（对于 StatefulWidget）。
- 在 `PainterDemoPage` 和 `CustomPainter` 类中说明：
  - `CustomPaint` 是一个 `RenderObjectWidget`。
  - 其 Element 会创建一个 `RenderCustomPaint`（RenderObject）。
  - `paint()` 是 RenderObject 树的 paint 阶段被 Engine 调用的。

注释不要太长，保持在 1~3 行之间，突出关键点即可。

---

## 最终输出格式

- 请只输出一个 **完整的 Dart 源码文件** 内容，即 `lib/main.dart` 的全部代码。
- 不需要任何额外解释或文字说明。
- 不要使用 Markdown 代码块包裹 Dart 代码（我会自己处理）。
- 确保代码可以直接复制到 `lib/main.dart` 中运行。