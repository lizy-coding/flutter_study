# 下载飞入动画演示

这是一个使用Flutter开发的下载飞入动画演示项目，展示了文件下载时的流畅动画效果。项目提供了三种不同的实现方式：**自定义 View 实现**、**Paint 绘制动画**和**Overlay 实现**，用户可以对比多种方案的效果差异。

### Overlay 实现

![download](https://github.com/lizy-coding/flutter_study/blob/master/download_animation_demo/assets/download.gif)

### paint 绘制

![paint_download](https://github.com/lizy-coding/flutter_study/blob/master/download_animation_demo/assets/paint_download.gif)


## 功能特性

### 🎯 核心功能
- **三种实现方案**：提供自定义 View、Paint 绘制和 Overlay 三种下载动效实现
- **效果对比页面**：并排展示不同实现方式，便于直观对比
- **动画参数控制**：实时调整动画参数，观察效果变化
- **响应式设计**：适配不同屏幕尺寸和设备

### 🔧 技术特性
- **自定义 View 实现**：基于 Stack 和 Positioned 的传统实现方式
- **Paint 绘制实现**：使用 CustomPaint 和 Canvas API 直接绘制动画
- **Overlay 实现**：基于全局 Overlay 的高级实现，不受视图层级限制
- **单例服务**：Overlay 服务采用单例模式，确保全局唯一性
- **资源管理**：完善的动画清理和资源释放机制
- **参数化配置**：支持通过配置对象自定义动画参数

## 动画参数设定方式与含义

项目使用`AnimationConfig`类统一管理所有动画参数，该类包含以下属性：

| 参数名 | 类型 | 默认值 | 含义 | 取值范围 |
|-------|------|-------|------|---------|
| `animationDuration` | int | 1500 | 动画持续时间（毫秒） | 500-3000 |
| `flyingItemOffset` | double | 30.0 | 飞入点的偏移量（控制大小） | 10-50 |
| `flyingItemPadding` | double | 8.0 | 飞入点内边距 | 4-16 |
| `flyingItemRadius` | double | 8.0 | 飞入点圆角半径 | 4-16 |
| `flyingSpeed` | double | 1.0 | 飞入动效速度倍数（1.0为正常速度） | 0.5-3.0 |

### 参数设置方法

1. **通过代码传入配置**：在创建`DownloadAnimationPage`时，可以通过构造函数传入自定义的`AnimationConfig`对象：

```dart
class DownloadAnimationPage (
  animationConfig: AnimationConfig(
    animationDuration: 2000,  // 2秒
    flyingItemOffset: 40.0,
    flyingItemPadding: 12.0,
    flyingItemRadius: 12.0,
    flyingSpeed: 1.5,  // 1.5倍速度
  ),
)
```

2. **通过UI控制面板调整**：点击页面右上角的设置图标，打开参数控制面板，使用滑块实时调整动画参数。

## 项目结构

```
lib/
├── main.dart                    # 应用入口，包含导航选择页面
├── models/
│   ├── animation_config.dart    # 动画配置参数类
│   ├── download_item.dart       # 下载项数据模型（自定义 View 用）
│   └── overlay_download_item.dart # Overlay 动画数据模型
├── pages/
│   ├── download_animation_page.dart    # 自定义 View 下载动画页面
│   ├── paint_animation_page.dart       # Paint 绘制动画页面
│   └── download_comparison_page.dart   # 两种实现方式对比页面
└── services/
    └── overlay_download_service.dart   # Overlay 下载动效服务类
```

## 使用方法

### 1. 运行项目

```bash
flutter run
```

### 2. 功能导航

启动应用后，主页面提供三个选项：

- **自定义 View 实现**：体验基于 Stack 和 Positioned 的传统实现方式
- **Paint 绘制动画**：体验使用 CustomPaint 和 Canvas API 绘制的动画效果
- **效果对比页面**：并排对比 Custom View 和 Overlay 实现方式的差异

### 3. 参数调整

在任一页面中，点击右上角的设置图标可打开参数控制面板，实时调整以下参数：

- 动画持续时间
- 飞行元素大小
- 内边距
- 圆角半径
- 飞入动效速度

## 技术实现要点

### 🎨 自定义 View 实现

- **动画系统**：使用 Flutter 的 AnimationController、Tween、CurvedAnimation 实现平滑动画
- **布局控制**：通过 Stack、Positioned、Transform、Opacity 控制动画元素
- **状态管理**：使用 StatefulWidget 和 setState 管理 UI 状态
- **参数配置**：通过 AnimationConfig 类统一管理动画参数

### 🖌️ Paint 绘制实现

- **CustomPainter**：继承 CustomPainter 实现自定义绘制逻辑
- **Canvas API**：使用 Canvas 的 drawCircle、drawPath 等方法直接绘制
- **视觉效果**：
  - 多层光晕效果（MaskFilter.blur）
  - 径向渐变圆圈（RadialGradient）
  - Path 绘制自定义图标
  - 运动轨迹尾迹效果
- **性能优化**：通过 shouldRepaint 控制重绘时机
- **动画集成**：使用 Listenable.merge 监听多个 AnimationController

### 🌐 Overlay 实现

- **全局覆盖**：使用 Flutter 的 Overlay 系统实现全局动画效果
- **单例模式**：OverlayDownloadService 采用单例设计，确保全局唯一性
- **资源管理**：提供完善的 OverlayEntry 创建、管理和清理机制
- **动画控制**：自定义 TickerProvider 解决 Overlay 中的 vsync 问题

### 🏗️ 架构设计

- **模块分离**：Models、Services、Pages 分层架构，职责清晰
- **可扩展性**：支持通过配置对象自定义动画参数
- **代码复用**：三种实现方式共享动画配置和数据模型
- **性能优化**：合理的资源管理和动画生命周期控制

## 三种实现方式对比

| 特性 | 自定义 View 实现 | Paint 绘制实现 | Overlay 实现 |
|------|-----------------|---------------|-------------|
| **适用场景** | 简单页面内动画 | 需要丰富视觉效果的动画 | 复杂视图层级、全局动画 |
| **实现复杂度** | 较低 | 中等 | 较高 |
| **视觉效果** | 基础 | 丰富（光晕、渐变、尾迹等） | 基础 |
| **性能** | 良好 | 优秀（直接绘制） | 需要注意资源清理 |
| **视图层级限制** | 受限于当前页面 | 受限于当前页面 | 不受限制，可覆盖任意内容 |
| **资源管理** | 相对简单 | 中等 | 需要手动管理 OverlayEntry |
| **使用建议** | 页面内简单动效 | 需要精细视觉效果的场景 | 复杂交互、跨页面动效 |

## 开发环境

- Flutter SDK: >=3.0.0
- Dart: >=3.0.0
- 支持平台：iOS、Android、Web、macOS、Windows、Linux

## 许可证

MIT License

