# AI 模块分析: tree_state

> Flutter 三棵树（Widget/Element/RenderObject）与生命周期演示。

## 功能

展示 Flutter 的 Widget 树、Element 树、RenderObject 树的关系，以及 StatefulWidget 生命周期和渲染行为。

## 文件结构

```
tree_state/
├── module_entry.dart              # 入口: 跳转到 DemoHomePage
├── routes.dart                    # 路由常量定义
└── pages/
    ├── demo_home_page.dart        # 仪表盘: 四个演示页面入口
    ├── basic_widgets_page.dart    # StatelessWidget vs StatefulWidget 重建行为
    ├── state_lifecycle_page.dart  # StatefulWidget 生命周期钩子
    ├── painter_demo_page.dart     # CustomPainter 渲染阶段日志
    └── repaint_boundary_demo_page.dart # 局部重绘与 RenderObject 隔离
```

## 演示内容

| 页面 | 核心概念 |
|------|---------|
| BasicWidgets | Widget 重建时机，const 优化 |
| StateLifecycle | initState, didChangeDependencies, build, dispose |
| PainterDemo | CustomPainter 的 paint 和 shouldRepaint 调用时机 |
| RepaintBoundary | RenderObject 层级的重绘隔离 |

## 关键知识点

1. **Widget**: 不可变的配置对象
2. **Element**: Widget 的实例，持有状态
3. **RenderObject**: 实际渲染和布局的对象
4. **const Widget**: 编译时常量，跳过重建
5. **RepaintBoundary**: 创建独立的 RenderObject，限制重绘范围

## 修改建议

- 添加 Element 树可视化: 展示 Widget -> Element 的映射关系
- 性能分析: 添加 rebuild 次数统计
- 交互演示: 允许用户手动触发重建观察变化
