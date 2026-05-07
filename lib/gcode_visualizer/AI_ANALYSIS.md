# G-code Visualizer 模块分析

> G-code 解析与轨迹动画演示模块。

## 功能目标

将 G-code 文本指令解析为结构化命令，生成刀路轨迹数据，并通过 CustomPaint 和 AnimationController 在 Canvas 上以动画形式展示执行过程。

## 文件结构

```
gcode_visualizer/
├── module_entry.dart              # 入口: 返回 GcodeVisualizerPage
├── AI_ANALYSIS.md                 # 模块分析文档
├── models/
│   ├── gcode_command.dart         # 解析后的指令模型 (G0/G1, X, Y, F)
│   ├── machine_position.dart      # 机床位置模型 (x, y, feedRate)
│   └── toolpath_segment.dart      # 轨迹段模型 (start, end, type)
├── parser/
│   ├── gcode_parse_result.dart    # 解析结果 (commands + errors)
│   └── gcode_parser.dart          # 纯 Dart 解析器
├── services/
│   └── toolpath_builder.dart      # 将指令列表转换为轨迹段列表
├── state/
│   └── gcode_player_controller.dart  # ChangeNotifier + AnimationController
├── widgets/
│   ├── command_timeline.dart      # 指令列表，高亮当前执行行
│   ├── gcode_canvas.dart          # CustomPaint 轨迹画布
│   ├── gcode_editor_panel.dart    # 多行文本编辑器 + 解析/示例按钮
│   └── playback_controls.dart     # 播放/暂停/重置/进度/速度控制
└── pages/
    └── gcode_visualizer_page.dart # 教学页面 (LearningScaffold)
```

## 数据流

```
source text (编辑器)
  -> GcodeParser.parse(source)
  -> GcodeParseResult(commands, errors)
  -> ToolpathBuilder.build(commands)
  -> List<ToolpathSegment>
  -> GcodePlayerController.progress (AnimationController)
  -> GcodeCanvas (CustomPaint repaint)
```

## 关键类

| 类 | 作用 |
|---|------|
| `GcodeParser` | 纯 Dart 文本解析器，支持 G0/G00/G1/G01，处理注释，输出结构化指令 |
| `ToolpathBuilder` | 将指令序列转换为轨迹段列表，跟踪机床当前位置 |
| `GcodePlayerController` | ChangeNotifier 状态管理，整合解析、轨迹构建、动画播放 |
| `_ToolpathPainter` | CustomPainter，负责坐标映射、网格、路径分层绘制 |
| `GcodeVisualizerPage` | 教学页面，使用 LearningScaffold 组织交互演示和教学内容 |

## 解析范围

### 支持 (v1)
- G0 / G00: 快速定位
- G1 / G01: 线性插补
- X / Y: 绝对坐标
- F: 进给率（存储但不模拟物理时间）
- `;` 行尾注释
- `()` 括号注释
- 大小写不敏感

### 延期
- G2/G3: 圆弧插补
- G20/G21: 英制/公制切换
- G90/G91: 绝对/增量模式切换
- Z 轴支持
- 刀具半径补偿
- 真实进给率计时
- 文件导入/导出
- Isolate 解析

## 绘制范围

| 图层 | 内容 | 样式 |
|------|------|------|
| 1 | 背景网格 | 浅灰 0.15 alpha |
| 2 | 完整路径 | 低透明度 |
| 3 | 快速段 (G0) | 蓝色，细线 |
| 4 | 线性段 (G1) | 绿色，粗线 |
| 5 | 已完成动画路径 | 高亮色 |
| 6 | 当前刀头标记 | 红色圆点 + 光晕 |
| 7 | 原点标记 | 橙色十字 |

### 坐标映射
- 计算 minX/maxX/minY/maxY
- 添加 padding
- fit scale = min(width/rangeX, height/rangeY)
- screenX = left + (machineX - minX) * scale
- screenY = bottom - (machineY - minY) * scale (Y 轴翻转)

## 状态管理

`GcodePlayerController` 使用 ChangeNotifier + AnimationController:
- `updateSource(String)` -> 更新编辑器内容
- `parse()` -> 解析并构建轨迹，重置播放状态
- `play()` / `pause()` / `reset()` -> 播放控制
- `seek(double)` -> 跳转进度
- `setSpeed(double)` -> 调整速度倍率

动画进度 0..1 映射到整个轨迹段列表，通过 `floor(progress * N)` 确定当前段索引。

## 修改注意事项

1. 解析器保持纯 Dart，不要引入 Flutter 依赖
2. 新增 G-code 指令支持时，同步更新 `_supportedCodes` 和 `ToolpathBuilder`
3. `CustomPainter.shouldRepaint` 仅依赖 progress 和 segments，避免不必要的重绘
4. 动画进度计算不应修改 segments 数据
5. 教学页面使用 LearningScaffold 组件，保持一致性

## 后续扩展计划

- 支持 G2/G3 圆弧插补（需要 Path.arcTo 或分段逼近）
- 支持多轴（Z 轴可视化，如颜色深浅表示 Z 高度）
- 真实进给率时间模拟（根据段长度和 F 值计算各段时间）
- 文件导入/导出功能
- Isolate 解析（大文件不阻塞 UI）
- 3D 视角切换
- 刀具路径仿真（显示刀具形状）
