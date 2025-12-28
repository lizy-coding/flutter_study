重构工作流 - 里程碑计划

目的
- 将 MIGRATION_PLAN.md 的执行计划拆分为可追踪的里程碑与操作清单
- 产出可持续维护的本地文档，避免上下文丢失

范围
- 入口统一已完成（main_app/lib/main.dart + app.dart）
- 当前计划覆盖剩余 40% 的整合工作

里程碑概览
- M1：清理冗余入口（14 个 main.dart）
- M2：统一路由跳转（Navigator.push -> go_router）
- M3：完善子路由注册（app_route_table.dart）
- M4：验证与回归（flutter analyze + 手动检查）

里程碑 M1：清理冗余入口

目标
- 删除 14 个模块的 main.dart，确保不再被编译依赖

操作清单
- 删除以下文件：
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
- 复查是否存在引用：rg "main.dart"（确保仅剩统一入口）

验收标准
- flutter analyze 无新增入口相关错误
- 删除文件未被 import/引用

里程碑 M2：统一路由跳转

目标
- 使用 go_router 替换 Navigator.push
- 保证各模块入口到子页面可达

待改文件与数量
- stream_subscription/pages/home_page.dart（2 处）
- microtask/features/home_page.dart（3 处）
- isolate_test/module_root.dart（2 处）
- download_animation_demo/module_root.dart（3 处）
- interceptor_test/pages/home_page.dart（1 处）

操作清单
- 将 Navigator.push 替换为 context.go 或 context.push
- 若需要返回结果，优先使用 context.push
- 统一路由路径与参数传递方式（query/extra）
- 复查替换结果：rg "Navigator.push"（仅保留必要场景）

验收标准
- 页面可正常跳转，无运行时异常
- 无残留 Navigator.push 造成行为不一致

里程碑 M3：完善子路由注册

目标
- 为所有子页面补充路由表注册

操作清单（app_route_table.dart）
- stream_subscription：/stream-demo, /broadcast-demo
- microtask：/event-queue, /microtask-queue, /advanced
- isolate_test：/with-isolate, /without-isolate
- download_animation_demo：补齐子页面路由
- interceptor_test：/login

验收标准
- 路由表中路径唯一且可达
- 跳转路径与页面实际入口一致

里程碑 M4：验证与回归

目标
- 保证整合后编译与导航正常

操作清单
- 运行 flutter analyze
- 逐模块验证入口 -> 子页面跳转
- 重点验证 microtask 与 interceptor_test 的冗余清理后功能完整性

验收标准
- flutter analyze 通过
- 所有模块入口与子页面跳转正常

执行顺序建议
- 先 M1，再 M2，接着 M3，最后 M4
- 每完成一个里程碑，进行一次小范围验证并记录结果

记录模板（可按里程碑追加）
- 里程碑：
- 实际完成时间：
- 完成摘要：
- 遗留问题：
- 验收结果：

执行记录
- 里程碑：M1
- 实际完成时间：2025-12-28 09:10:23
- 完成摘要：删除 14 个模块 main.dart；rg --files -g 'main.dart' lib 仅剩 lib/main.dart
- 遗留问题：无
- 验收结果：rg "main.dart" lib 仅剩注释

- 里程碑：M2
- 实际完成时间：2025-12-28 09:10:23
- 完成摘要：5 个模块入口替换为 context.push；rg "Navigator.push" 无结果
- 遗留问题：无
- 验收结果：未运行 Flutter 实机验证

- 里程碑：M3
- 实际完成时间：2025-12-28 09:10:23
- 完成摘要：补齐 stream_subscription/microtask/isolate_test/download_animation_demo/interceptor_test 子路由注册
- 遗留问题：无
- 验收结果：未运行 Flutter 实机验证

- 里程碑：M4
- 实际完成时间：待执行
- 完成摘要：未执行
- 遗留问题：flutter analyze + 手动验证待完成
- 验收结果：未验证
