# Flutter Forge macOS WebView / G-code 发版自测计划

状态：`REVIEW_PENDING`

用途：在融合 WebView 三端能力及 `gcode_core v0.2.0-dev.1` 后，对最终 macOS Release 候选执行可追溯的真机验收。本文件是执行计划，不代表任何项目已经通过。

## 1. 放行原则

只有以下所有必测项为 `PASS` 时，`MACOS_RELEASE_GATE` 才能设为 `PASS`。存在未提交源码、产物提交不一致、原生测试未完成、黑屏、崩溃、未处理异常、`Invalid engine handle` 或 `Failed to send message to Flutter engine` 时，结论必须为 `HOLD`。

macOS 结果只决定 macOS Release 是否可发布，不能替代 Windows WebView2 或 Android 真机验收。

## 2. 当前已知边界

| 项目 | 当前状态 | 发版前要求 |
|---|---|---|
| WebView 模块接入 | 已提交 | 基于最终候选重新验证 |
| macOS WKWebView 自动化 | `PENDING`，此前卡在 Xcode compiler probe | 必须完成真实 WKWebView 测试 |
| G-code 依赖 | 工作区指向 `v0.2.0-dev.1` | 固定并解析到明确 commit |
| G-code 核心能力 | `gcode_core` 已完成独立验证 | 本轮不重复解析、算法和完整 GPU 能力测试 |
| G-code Forge 集成 | 工作区升级到新版本 | 只验证依赖解析、模块启动、首帧和退出重进 |
| 工作区 | 当前有未提交改动 | 发版候选必须提交并保持干净 |
| Windows WebView2 | 本轮不具备 Windows 主机证据 | 保持 `PENDING` |

## 3. 测试基线

执行前填写：

| 字段 | 记录 |
|---|---|
| 执行人 |  |
| 执行日期 |  |
| Git commit |  |
| Git branch |  |
| `git status --porcelain` | 必须为空 |
| 应用版本 |  |
| Flutter / Dart 版本 |  |
| macOS 版本 |  |
| Mac 型号、CPU、内存 |  |
| G-code ref | `v0.2.0-dev.1` |
| G-code resolved commit |  |
| WebView Flutter/WKWebView 版本 |  |
| Release `.app` 路径 |  |
| Release SHA256 |  |
| 原始日志目录 | `macos_acceptance/evidence/YYYY-MM-DD-webview-gcode/` |

基线命令：

```bash
git status --porcelain
git rev-parse HEAD
git branch --show-current
flutter --version
sw_vers
uname -m
sed -n '1,80p' apps/flutter_forge/pubspec.yaml
sed -n '300,335p' pubspec.lock
```

## 4. 自动门禁

从仓库根目录依次执行，任一步失败即停止发版：

```bash
bash tool/quality_gate.sh

cd apps/flutter_forge
flutter test test/modules/platform/webview
flutter test test/modules/ui/gcode_visualizer/gcode_visualizer_test.dart
FLUTTER_XCODE_CC="$PWD/tool/macos/compiler_probe.py" flutter test integration_test/webview_macos_test.dart -d macos
FLUTTER_XCODE_CC="$PWD/tool/macos/compiler_probe.py" flutter build macos --release
```

| ID | 检查 | 预期 | 结果 | 证据 |
|---|---|---|---|---|
| A1 | 工作区干净 | `git status --porcelain` 无输出 | NOT_RUN |  |
| A2 | Agent 文档 | 生成与校验无漂移 | NOT_RUN |  |
| A3 | 格式和分析 | 无 error、warning、info | NOT_RUN |  |
| A4 | 全量测试 | 所有 workspace suite 通过 | NOT_RUN |  |
| A5 | FlutterGuard | 无 HIGH | NOT_RUN |  |
| A6 | WebView 单元/Widget 测试 | URL、安全、状态、释放、平台声明通过 | NOT_RUN |  |
| A7 | G-code Forge 消费测试 | 当前依赖下模块 Widget 可构建并显示关键入口 | NOT_RUN |  |
| A8 | WKWebView 原生集成测试 | 加载、后退、前进、刷新、销毁重建通过 | NOT_RUN |  |
| A9 | macOS Release 构建 | `Flutter Forge.app` 生成 | NOT_RUN |  |

若 A8 再次停在 compiler probe，保存 `flutter test -v`、`xcodebuild` 进程树和采样日志，结果填写 `BLOCKED`，不得用 A6 替代。

## 5. Release 产物身份

只操作本轮 A9 生成的完整路径：

```text
apps/flutter_forge/build/macos/Build/Products/Release/Flutter Forge.app
```

执行并保存输出：

```bash
shasum -a 256 "apps/flutter_forge/build/macos/Build/Products/Release/Flutter Forge.app/Contents/MacOS/Flutter Forge"
plutil -p "apps/flutter_forge/build/macos/Build/Products/Release/Flutter Forge.app/Contents/Info.plist"
codesign -dv --verbose=4 "apps/flutter_forge/build/macos/Build/Products/Release/Flutter Forge.app" 2>&1
```

| ID | 检查 | 预期 | 结果 | 证据 |
|---|---|---|---|---|
| P1 | commit 与产物对应 | 构建日志记录最终 commit | NOT_RUN |  |
| P2 | 应用版本 | 与候选版本一致 | NOT_RUN |  |
| P3 | 最低系统版本 | 与 macOS 12+ 契约一致 | NOT_RUN |  |
| P4 | Impeller/Flutter GPU | Release 配置包含预期能力 | NOT_RUN |  |
| P5 | WKWebView 注册 | Release 中插件已注册 | NOT_RUN |  |
| P6 | SHA256 | 已记录且后续测试不再重建产物 | NOT_RUN |  |

## 6. 启动和日志

关闭所有旧版 Flutter Forge 进程，然后直接启动上述 Release `.app`。至少执行两次完整启动，并为每轮记录 PID、SHA256、启动时间和原始日志。

| ID | 操作 | 预期 | 结果 | 证据 |
|---|---|---|---|---|
| S1 | 第一次冷启动 | 主窗口完成首帧，无黑屏或异常退出 | NOT_RUN |  |
| S2 | 完全退出后第二次启动 | 可重复启动，状态正常 | NOT_RUN |  |
| S3 | 启动日志 | 无 fatal、未处理异常、Engine 消息错误 | NOT_RUN |  |
| S4 | 崩溃报告 | 无本轮 Flutter Forge crash | NOT_RUN |  |

## 7. WebView macOS 真机专项

建议先加载稳定的 HTTPS 页面，再加载一个不同页面形成历史记录。所有交互均在当前 Flutter Forge 窗口内完成。

| ID | 操作 | 预期 | 结果 | 证据 |
|---|---|---|---|---|
| W1 | 从“网络与平台”进入 WebView | 页面出现，无插件未注册异常 | NOT_RUN |  |
| W2 | 加载默认 HTTPS 页面 | 占位状态出现后网页正常显示 | NOT_RUN |  |
| W3 | 输入第二个 HTTPS 地址并打开 | 地址和页面更新 | NOT_RUN |  |
| W4 | 网页后退、前进 | 页面历史和按钮状态正确 | NOT_RUN |  |
| W5 | 刷新 | 当前页面重新加载并恢复显示 | NOT_RUN |  |
| W6 | 输入 `javascript:`、`file:` 或非法地址 | 拒绝导航并显示明确错误 | NOT_RUN |  |
| W7 | 断网或不可达地址 | 显示失败/重试状态，不永久停在成功态 | NOT_RUN |  |
| W8 | 退出模块后重新进入 3 次 | WKWebView 可重建，无晚到回调异常 | NOT_RUN |  |
| W9 | 紧凑窗口约 360dp | 输入框、按钮、网页区域可操作，无 overflow | NOT_RUN |  |
| W10 | WebView 日志 | 无 WKWebView、PlatformView、dispose 致命错误 | NOT_RUN |  |

必须保存：首次加载、第二页面、历史导航、非法地址、失败态、第三次重开后的截图，以及 W1-W10 对应原始日志。

## 8. G-code Forge 集成冒烟

`gcode_core` 的解析、轨迹算法、Flutter GPU 绘制和完整交互由其独立仓库验收，本轮不重复执行。本节只证明 Forge 的最终 Release 能解析依赖并启动 G-code 模块。

| ID | 操作 | 预期 | 结果 | 证据 |
|---|---|---|---|---|
| G1 | 从 UI 分类进入 G-code 模块 | 模块成功启动，无依赖或插件加载错误 | NOT_RUN |  |
| G2 | 检查模块首帧 | 编辑器、画布、时间线和播放控件出现 | NOT_RUN |  |
| G3 | 返回后再次进入 | 模块可重新启动，无黑屏或异常退出 | NOT_RUN |  |
| G4 | 检查启动日志 | 无 package resolution、Shader、Impeller 或 Flutter GPU 致命错误 | NOT_RUN |  |

必须保存：首次启动、首帧、再次进入的截图，以及 G1-G4 对应原始日志。无需准备额外 G-code 测试文件，也无需重复核心包的性能与算法验收。

## 9. 多窗口与交叉回归

WebView 和 G-code 都必须在真实桌面分类窗口中验证，避免只证明主窗口应用内导航。

| ID | 操作 | 预期 | 结果 | 证据 |
|---|---|---|---|---|
| M1 | 同时打开基础、UI、网络与平台分类 | 三个窗口首帧正常 | NOT_RUN |  |
| M2 | UI 分类打开 G-code | 模块启动并完成首帧 | NOT_RUN |  |
| M3 | 网络与平台分类打开 WebView | WKWebView 正常 | NOT_RUN |  |
| M4 | 同分类重复打开 | 复用已有窗口 | NOT_RUN |  |
| M5 | 关闭并重开分类窗口 3 轮 | 两个模块仍可使用，无黑屏 | NOT_RUN |  |
| M6 | 子窗口打开并取消文件选择器 | 原生对话框正常返回 | NOT_RUN |  |
| M7 | 检查窗口日志 | 无 `Invalid engine handle` | NOT_RUN |  |
| M8 | 检查 Engine 消息 | 无 `Failed to send message to Flutter engine` | NOT_RUN |  |

## 10. 最终判定

| Gate | 条件 | 结论 |
|---|---|---|
| `STATIC_GATE` | A1-A6 全部通过 | PENDING |
| `MACOS_NATIVE_GATE` | A8-A9、P1-P6、S1-S4 全部通过 | PENDING |
| `WEBVIEW_GATE` | W1-W10 全部通过 | PENDING |
| `GCODE_INTEGRATION_GATE` | A7、G1-G4 全部通过 | PENDING |
| `DESKTOP_REGRESSION_GATE` | M1-M8 全部通过 | PENDING |
| `MACOS_RELEASE_GATE` | 上述五个 Gate 全部为 PASS | HOLD |

最终报告必须包含：最终 commit、版本、Release SHA256、Mac 环境、每个 Gate 的结论、失败项、原始日志路径和截图索引。执行期间若修改任何源码、依赖、Podfile、Xcode 配置或生成器，必须重新冻结 commit，并从 A1 重新开始。
