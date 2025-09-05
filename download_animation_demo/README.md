# 下载飞入动画演示

这是一个使用Flutter开发的下载飞入动画演示项目，展示了文件下载时的流畅动画效果。用户可以点击文件列表中的下载按钮，观察文件图标以动画形式飞入下载中心的效果。

## 功能特性

- 直观的文件下载动画效果
- 可自定义的动画参数（动画持续时间、飞入点大小、内边距、圆角）
- 动画参数控制面板，支持实时调整
- 响应式UI设计，适配不同屏幕尺寸
- 支持通过配置对象传入自定义动画参数

## 动画参数设定方式与含义

项目使用`AnimationConfig`类统一管理所有动画参数，该类包含以下属性：

| 参数名 | 类型 | 默认值 | 含义 | 取值范围 |
|-------|------|-------|------|---------|
| `animationDuration` | int | 1500 | 动画持续时间（毫秒） | 500-3000 |
| `flyingItemOffset` | double | 30.0 | 飞入点的偏移量（控制大小） | 10-50 |
| `flyingItemPadding` | double | 8.0 | 飞入点内边距 | 4-16 |
| `flyingItemRadius` | double | 8.0 | 飞入点圆角半径 | 4-16 |

### 参数设置方法

1. **通过代码传入配置**：在创建`DownloadAnimationPage`时，可以通过构造函数传入自定义的`AnimationConfig`对象：

```dart
DownloadAnimationPage(
  animationConfig: AnimationConfig(
    animationDuration: 2000,  // 2秒
    flyingItemOffset: 40.0,
    flyingItemPadding: 12.0,
    flyingItemRadius: 12.0,
  ),
)
```

2. **通过UI控制面板调整**：点击页面右上角的设置图标，打开参数控制面板，使用滑块实时调整动画参数。

## 项目结构

```
lib/
├── main.dart           # 应用入口
├── models/
│   ├── animation_config.dart  # 动画配置参数类
│   └── download_item.dart     # 下载项数据模型
└── pages/
    └── download_animation_page.dart  # 下载动画页面实现
```

## 技术实现要点

- 使用Flutter的动画系统（AnimationController、Tween、CurvedAnimation）实现平滑动画
- 通过Transform、Opacity等组件控制动画元素的位置、缩放和透明度
- 使用StatefulWidget和setState管理UI状态和动画参数
- 采用组合式API设计，使动画配置可通过参数传入
- 代码结构清晰，职责分离，易于维护和扩展

