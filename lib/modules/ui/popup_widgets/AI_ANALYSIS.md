# AI 模块分析: popup_widgets

> Flutter 弹窗/对话框完整合集。

## 功能

展示 Flutter 中所有常见的弹窗类型，包括 AlertDialog、SimpleDialog、BottomSheet、Cupertino 对话框、自定义对话框、Overlay 链式弹窗等。

## 文件结构

```
modules/ui/popup_widgets/
├── module_entry.dart          # 入口: 跳转到 PopDemoHomePage
└── module_root.dart           # 所有弹窗演示（~895 行）
```

## 弹窗类型

| 类型 | 触发方式 | 说明 |
|------|---------|------|
| AlertDialog | 按钮点击 | 标准警告对话框 |
| SimpleDialog | 按钮点击 | 简单选择对话框 |
| Modal Bottom Sheet | 按钮点击 | 模态底部抽屉 |
| Cupertino AlertDialog | 双击触发 | iOS 风格警告框 |
| Custom Dialog | 按钮点击 | 自定义对话框 |
| Persistent BottomSheet | 按钮点击 | 持久底部抽屉 |
| DatePicker | 按钮点击 | 日期选择器 |
| TimePicker | 按钮点击 | 时间选择器 |
| AboutDialog | 按钮点击 | 关于对话框 |
| Exit Confirmation | WillPopScope | 退出确认 |
| Context Menu | showMenu | 右键菜单 |
| Chain Dialogs (Navigator) | 按钮点击 | Navigator 链式弹窗 |
| Chain Dialogs (Overlay) | 按钮点击 | OverlayEntry 链式，支持拖拽排序 |

## 修改建议

- 新增弹窗类型: 在 module_root.dart 中添加新的演示方法
- 重构建议: module_root.dart 过大（895行），可拆分为多个独立页面
- 样式定制: 使用 Theme 或自定义 Dialog 样式
