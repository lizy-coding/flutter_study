重构计划 - 工程整合（剩余 40%）

  一、当前状态分析

  已完成（60%）：
  - 统一入口 main_app/lib/main.dart + app.dart
  - GoRouter 路由框架搭建 (router/app_router.dart, app_route_table.dart)
  - 14 个模块的 module_entry.dart 入口文件
  - 主页模块列表导航 ModuleHomePage

  待完成问题：

  | 问题                                               | 涉及模块数 |
  |--------------------------------------------------|-------|
  | 1. 冗余 main.dart 文件未删除                            | 14 个  |
  | 2. 子页面仍使用 Navigator.push 而非 go_router            | 6 个模块 |
  | 3. 部分模块缺少子路由注册                                   | 多个    |
  | 4. microtask/main.dart 含大量冗余代码 EventDemoPage     | 1 个   |
  | 5. interceptor_test/main.dart 含模板冗余代码 MyHomePage | 1 个   |

  ---
  二、执行计划

  阶段 1：清理冗余 main.dart（14 个文件）

  删除以下分包的 main.dart：
  - adsorption_line/main.dart
  - debounce_throttle/main.dart
  - download_animation_demo/main.dart
  - flutter_ioc/main.dart
  - interceptor_test/main.dart
  - isolate_stream_demo/main.dart
  - isolate_test/main.dart
  - microtask/main.dart
  - pop_widget/main.dart
  - scroll_table/main.dart
  - status_manage/main.dart
  - stream_subscription/main.dart
  - tree_state/main.dart
  - usb_detector_demo/main.dart

  阶段 2：统一路由跳转（Navigator.push -> go_router）

  需要修改的模块：
  1. stream_subscription - pages/home_page.dart (2处)
  2. microtask - features/home_page.dart (3处)
  3. isolate_test - module_root.dart (2处)
  4. download_animation_demo - module_root.dart (3处)
  5. interceptor_test - pages/home_page.dart (1处)

  阶段 3：完善子路由注册

  在 app_route_table.dart 中为以下模块添加子路由：
  - stream_subscription - 添加 /stream-demo, /broadcast-demo
  - microtask - 添加 /event-queue, /microtask-queue, /advanced
  - isolate_test - 添加 /with-isolate, /without-isolate
  - download_animation_demo - 添加子页面路由
  - interceptor_test - 添加 /login 路由

  阶段 4：验证与测试

  - 运行 flutter analyze 检查编译错误
  - 验证各模块导航功能正常

  ---
  三、预计工作量

  | 阶段   | 文件数   | 复杂度 |
  |------|-------|-----|
  | 阶段 1 | 14    | 低   |
  | 阶段 2 | 5     | 中   |
  | 阶段 3 | 1 + 5 | 中   |
  | 阶段 4 | -     | 低   |