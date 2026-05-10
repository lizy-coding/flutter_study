# AI 模块分析: isolate_basic

> 主线程 vs Isolate 执行耗时计算的 UI 流畅度对比。

## 功能

通过埃拉托斯特尼筛法计算质数，对比在主线程和 Isolate 中执行时 UI 的响应性差异。

## 文件结构

```
modules/async/isolate_basic/
├── module_entry.dart          # 入口: 跳转到 HomePage
├── module_root.dart           # 导航页: 两个按钮（无 Isolate / 有 Isolate）
├── without_isolate_page.dart  # 主线程计算，UI 卡顿
└── with_isolate_page.dart     # Isolate 计算，UI 流畅
```

## 对比说明

| 方式 | UI 响应性 | 进度更新 | 实现方式 |
|------|----------|---------|---------|
| 无 Isolate | 卡顿 | 无 | 直接调用计算函数 |
| 有 Isolate | 流畅 | 实时 | Isolate.spawn + ReceivePort |

## 修改建议

- 增加计算量: 调整质数计算的上限
- 添加更多对比: 如 compute() vs Isolate.spawn
- 可视化优化: 添加 FPS 指示器展示帧率变化
