# AI 模块分析: microtask

> Flutter 事件循环机制演示：微任务队列 vs 事件队列。

## 功能

可视化展示 Dart 事件循环中微任务队列（Microtask Queue）和事件队列（Event Queue）的执行顺序和优先级差异。

## 文件结构

```
modules/basic/microtask/
├── module_entry.dart          # 入口: 跳转到 HomePage
├── features/
│   ├── home_page.dart         # 仪表盘: 解释两种队列
│   ├── event_queue/
│   │   └── event_queue_page.dart       # 事件队列示例
│   ├── microtask_queue/
│   │   └── microtask_queue_page.dart   # 微任务队列示例
│   └── advanced_examples/
│       └── advanced_examples_page.dart # async/await, Future, Zones
└── core/
    ├── models/
    │   └── event_log.dart             # 事件日志模型
    └── widgets/
        ├── code_snippet_view.dart     # 代码片段展示
        └── event_log_view.dart        # 事件日志展示
```

## 关键概念

| 概念 | 说明 |
|------|------|
| Microtask Queue | 高优先级队列，通过 `scheduleMicrotask()` 添加 |
| Event Queue | 普通优先级，I/O、定时器、用户事件 |
| 执行顺序 | Microtask Queue 清空后才会执行 Event Queue |

## 示例页面

1. **EventQueuePage**: 展示 Future.delayed、Timer 等事件队列行为
2. **MicrotaskQueuePage**: 展示 scheduleMicrotask 的微任务行为
3. **AdvancedExamplesPage**: async/await、Future 链式调用、Zones

## 修改建议

- 添加新示例: 在对应 page 中添加新的演示代码
- 可视化增强: 添加动画展示队列执行过程
- 交互改进: 允许用户逐步执行观察队列状态
