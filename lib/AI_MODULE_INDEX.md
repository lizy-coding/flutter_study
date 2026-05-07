# AI 模块索引

> 此文件描述 lib/ 下所有模块的结构，AI 修改模块代码前请查阅对应模块的 AI_ANALYSIS.md。

## 模块列表

| 模块 | 入口路径 | 状态管理 | 复杂度 | AI 分析文件 |
|------|---------|---------|--------|------------|
| adsorption_line | /adsorption-line | ChangeNotifier + Provider | 高 | `adsorption_line/AI_ANALYSIS.md` |
| debounce_throttle | /debounce-throttle | StatefulWidget | 低 | `debounce_throttle/AI_ANALYSIS.md` |
| download_animation_demo | /download-animation | StatefulWidget | 中 | `download_animation_demo/AI_ANALYSIS.md` |
| flutter_ioc | /flutter-ioc | 自研 IoC + Provider | 中 | `flutter_ioc/AI_ANALYSIS.md` |
| gcode_visualizer | /gcode-visualizer | ChangeNotifier + AnimationController | 高 | `gcode_visualizer/AI_ANALYSIS.md` |
| interceptor_test | /interceptor-test | 无（Dio 拦截器） | 中 | `interceptor_test/AI_ANALYSIS.md` |
| isolate_stream_demo | /isolate-stream | StatefulWidget | 中 | `isolate_stream_demo/AI_ANALYSIS.md` |
| isolate_test | /isolate-test | StatefulWidget | 低 | `isolate_test/AI_ANALYSIS.md` |
| microtask | /microtask | StatefulWidget | 低 | `microtask/AI_ANALYSIS.md` |
| pop_widget | /pop-widget | StatefulWidget | 中 | `pop_widget/AI_ANALYSIS.md` |
| scroll_table | /scroll-table | 无 | 低 | `scroll_table/AI_ANALYSIS.md` |
| status_manage | /status-manage | Provider/Riverpod/Bloc | 高 | `status_manage/AI_ANALYSIS.md` |
| stream_subscription | /stream-subscription | StreamController | 中 | `stream_subscription/AI_ANALYSIS.md` |
| tree_state | /tree-state | StatefulWidget | 低 | `tree_state/AI_ANALYSIS.md` |
| usb_detector_demo | /usb-detector | StreamController | 中 | `usb_detector_demo/AI_ANALYSIS.md` |

## 模块模式分类

### 模式 A: 简单入口（module_entry -> module_root）
- debounce_throttle
- download_animation_demo
- flutter_ioc
- isolate_stream_demo
- isolate_test
- pop_widget
- scroll_table
- usb_detector_demo

### 模式 B: 功能分区（无 module_root，直接 features/pages 组织）
- adsorption_line（models/state/services/widgets）
- gcode_visualizer（models/parser/services/state/widgets/pages）
- interceptor_test（pages/network/models/mock_server）
- microtask（features/core）
- status_manage（app/features/shared）
- stream_subscription（pages/services/utils/models）
- tree_state（pages/routes）
