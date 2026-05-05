# AI 模块分析: debounce_throttle

> 防抖与节流执行时序对比演示。

## 功能

通过按钮点击和滚动两个场景，可视化展示防抖（debounce）与节流（throttle）的区别。

## 文件结构

```
debounce_throttle/
├── module_entry.dart          # 入口: 跳转到 MyHomePage
├── module_root.dart           # PageView: ButtonScene + ScrollScene
└── utils/
    └── debounce_throttle.dart # Debouncer 和 Throttle 实现
```

## 核心实现

| 类 | 行为 |
|---|------|
| `Debouncer` | 取消之前的 Timer，延迟后执行动作 |
| `Throttle` | 首次立即执行，在时间窗口内忽略后续调用 |

## 场景

1. **ButtonScene**: 快速点击按钮，对比普通/防抖/节流的触发次数
2. **ScrollScene**: 滚动时对比实时/防抖/节流的位置指示器

## 修改建议

- 调整延迟时间: 修改 `Debouncer`/`Throttle` 构造函数的 duration
- 添加新场景: 在 `module_root.dart` 中添加新的 Scene Widget
- 可视化增强: 使用动画展示事件触发时间线
