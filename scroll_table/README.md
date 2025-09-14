# scroll_table

二维滚动表格 Flutter 应用演示项目。

## 项目简介

这是一个使用 Flutter 开发的二维滚动表格演示应用，展示了如何实现支持横向和纵向滚动的数据表格，具有固定表头和行头功能。

## 功能特性

- ✅ 二维滚动支持：横向和纵向滚动
- ✅ 固定表头：首行表头在纵向滚动时保持固定
- ✅ 固定行头：首列行头在横向滚动时保持固定
- ✅ 自定义样式：支持交替行颜色、单元格大小调整
- ✅ 响应式布局：适配不同屏幕尺寸
- ✅ 数据展示：员工信息表格演示

## 技术栈

- **Flutter SDK**: ^3.5.0
- **核心依赖**:
  - `two_dimensional_scrollables`: ^0.3.0 - 二维滚动组件
  - `cupertino_icons`: ^1.0.8 - iOS 风格图标

## 项目结构

```
lib/
├── main.dart                # 应用入口和主页面
└── widgets/
    └── scroll_table.dart    # 二维滚动表格组件实现
```

## 快速开始

### 环境要求

- Flutter SDK >= 3.5.0
- Dart SDK >= 3.5.0

### 安装和运行

1. 克隆项目：
```bash
git clone <repository-url>
cd scroll_table
```

2. 获取依赖：
```bash
flutter pub get
```

3. 运行应用：
```bash
flutter run
```

## 核心组件

### ScrollTable 组件

位于 `lib/widgets/scroll_table.dart`，主要特性：

- 使用 `two_dimensional_scrollables` 包的 `TableView.builder`
- 支持自定义列头、行头和数据
- 可配置单元格尺寸
- 内置样式和交互逻辑

### 使用示例

```dart
ScrollTable(
  columnHeaders: ['姓名', '年龄', '部门', '职位'],
  rowHeaders: ['第1行', '第2行', '第3行'],
  data: [
    ['张三', '25', '技术部', '工程师'],
    ['李四', '30', '销售部', '经理'],
    // ...
  ],
  cellHeight: 56.0,
  cellWidth: 140.0,
)
```

## 支持平台

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 开发指南

### 添加新功能

1. 在 `lib/widgets/` 目录下创建新组件
2. 在 `main.dart` 中引用和使用
3. 运行测试确保功能正常

### 自定义样式

可以通过修改 `scroll_table.dart` 中的以下属性来自定义外观：

- 单元格颜色
- 边框样式
- 文本样式
- 单元格尺寸

## 许可证

此项目仅用于学习和演示目的。
