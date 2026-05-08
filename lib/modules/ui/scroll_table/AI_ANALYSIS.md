# AI 模块分析: scroll_table

> 二维滚动表格，固定表头/行头。

## 功能

使用 `two_dimensional_scrollables` 包实现二维滚动表格，支持固定列头和行头。

## 文件结构

```
modules/ui/scroll_table/
├── module_entry.dart          # 入口: 跳转到 ScrollTableDemo
├── module_root.dart           # 演示页: 员工信息表格
└── widgets/
    └── scroll_table.dart      # ScrollTable Widget + TableData 辅助类
```

## 核心实现

| 类 | 作用 |
|---|------|
| `ScrollTable` | 使用 TableView.builder 构建二维表格 |
| `TableData` | 辅助类，提供示例员工数据（20 行 x 8 列） |

## 关键配置

- `pinnedColumnCount: 1`: 固定第一列（行头）
- `pinnedRowCount: 1`: 固定第一行（列头）

## 修改建议

- 修改数据: 调整 TableData 中的示例数据
- 添加交互: 支持单元格编辑、排序、筛选
- 样式定制: 修改单元格样式、交替行颜色
- 大数据优化: 实现虚拟滚动或分页加载
