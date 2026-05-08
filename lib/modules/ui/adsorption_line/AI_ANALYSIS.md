# AI 模块分析: adsorption_line

> 智能吸附线画板，类似 Figma 的对齐辅助功能。

## 功能

支持矩形/圆形/线条的创建、拖拽、选中、删除，拖拽时自动检测相邻元素并显示吸附辅助线。

## 文件结构

```
modules/ui/adsorption_line/
├── module_entry.dart          # 入口: ChangeNotifierProvider<drawingState>
├── models/
│   └── drawing_element.dart   # DrawingElement 模型 (矩形/圆/线)
├── state/
│   └── drawing_state.dart     # ChangeNotifier: 元素 CRUD、选中、拖拽状态
├── services/
│   └── adsorption_manager.dart # 静态服务: 计算吸附线，带延迟隐藏
└── widgets/
    ├── drawing_board.dart     # 主 UI: 工具栏 + 画布 + 状态栏
    └── drawing_canvas.dart    # CustomPaint: 渲染元素和吸附线
```

## 数据流

```
用户操作 (DrawingBoard)
  → GestureDetector (DrawingCanvas)
    → DrawingState.updateElementPosition()
      → AdsorptionManager.calculateSnapLines()
        → DrawingState 更新吸附线
          → notifyListeners() → UI 重绘
```

## 关键类

| 类 | 作用 |
|---|------|
| `DrawingElement` | 元素基类，RectangleElement/CircleElement/LineElement 继承 |
| `DrawingState` | ChangeNotifier，管理 elements、selectedElement、snapLines |
| `AdsorptionManager` | 静态类，计算元素间对齐关系，返回 SnapLine 列表 |
| `DrawingCanvas` | CustomPainter 实现，处理命中检测和拖拽手势 |

## 修改建议

- 新增元素类型: 继承 `DrawingElement`，在 `DrawingCanvas` 的 paint 中添加渲染逻辑
- 修改吸附逻辑: 调整 `AdsorptionManager` 的阈值和计算方式
- 添加撤销/重做: 在 `DrawingState` 中维护命令栈
