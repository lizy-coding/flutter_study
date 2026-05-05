# AI 路由分析

> 修改路由配置前请阅读此文件。

## 文件职责

| 文件 | 职责 |
|------|------|
| `app_router.dart` | 创建 GoRouter 单例，传入 routes |
| `app_route_table.dart` | 定义所有路由、模块列表、ModuleEntry 模型 |

## 关键类

### ModuleEntry
模块注册单元，包含：
- `title`: 模块显示名称
- `path`: 路由路径（kebab-case，如 `/my-module`）
- `builder`: 模块入口 Widget 构建函数
- `subtitle`: 可选副标题
- `routes`: 子路由列表（`List<GoRoute>`）

### 路由注册流程
1. 首页 `/` 渲染 `ModuleHomePage`，展示所有模块列表
2. 点击模块后 `context.push(module.path)` 导航
3. 子路由定义在模块的 `routes` 字段中

## 子路由定义模式

目前有两种模式：

### 模式 1: 在 app_route_table.dart 中内联定义
```dart
final List<GoRoute> _myModuleRoutes = [
  GoRoute(
    path: _stripLeadingSlash('/sub-page'),
    builder: (context, state) => const MySubPage(),
  ),
];

// 在 _modules 中传入
ModuleEntry(
  title: 'My Module',
  path: '/my-module',
  builder: (context) => const MyModuleEntry(),
  routes: _myModuleRoutes,
),
```

### 模式 2: 由模块自身导出路由表（如 status_manage）
```dart
// status_manage/app/app_routes.dart 定义路由映射
final List<GoRoute> _statusManageRoutes = AppRoutes.routes.entries
    .map((entry) => GoRoute(
      path: _stripLeadingSlash(entry.key),
      builder: (context, state) => entry.value(context),
    ))
    .toList();
```

## 注意事项

- 子路由 path 不需要前缀 `/`，`_stripLeadingSlash` 会处理
- 新增模块必须同时 import 入口和注册到 `_modules`
- 路由路径与模块目录名可以不同，但建议保持一致
