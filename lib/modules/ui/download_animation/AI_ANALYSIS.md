# AI 模块分析: download_animation

> 下载飞入动效三种实现方式的对比演示。

## 功能

展示文件下载完成后，从列表位置飞入下载中心的动画效果，提供三种实现方式对比。

## 文件结构

```
modules/ui/download_animation/
├── module_entry.dart                # 入口: 跳转到 HomePage
├── module_root.dart                 # 导航页: 三个子页面入口
├── models/
│   ├── animation_config.dart        # 动画参数配置
│   ├── download_item.dart           # 下载项模型
│   └── overlay_download_item.dart   # Overlay 下载项模型
├── pages/
│   ├── download_animation_page.dart # 主动画页: 文件列表 + 控制面板 + 飞入动画
│   ├── paint_animation_page.dart    # CustomPaint 实现
│   └── download_comparison_page.dart # 自定义 View vs Overlay 对比
└── services/
    └── overlay_download_service.dart # Overlay 下载服务
```

## 三种实现

| 方式 | 页面 | 特点 |
|------|------|------|
| Custom View | download_animation_page | 使用 AnimatedContainer/Tween 动画 |
| CustomPaint | paint_animation_page | 在 CustomPainter 中绘制动画 |
| Overlay | comparison | 使用 OverlayEntry 实现全局浮层 |

## 关键参数 (AnimationConfig)

- `animationDuration`: 动画时长（默认 2000ms）
- `flyingItemOffset`: 飞行项偏移
- `flyingItemPadding`: 飞行项内边距
- `flyingItemRadius`: 飞行项圆角

## 修改建议

- 调整动画曲线: 修改 Tween 的 curve 参数
- 新增动画效果: 添加新的动画参数到 AnimationConfig
- 扩展 Overlay: 在 overlay_download_service 中添加更多动画类型
