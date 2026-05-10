# AI 路由分析

> 修改路由配置前请阅读此文件。

## 架构：全局路由集中管理

采用 **模块自治 + 路由表聚合** 模式：
- 每个模块在内部定义自己的 `module_routes.dart`，管理子路由
- `app/router/app_route_table.dart` 只负责聚合所有模块，不定义子路由细节

## 文件职责

| 文件 | 职责 |
|------|------|
| `app/router/app_router.dart` | 创建 GoRouter 单例，传入 routes |
| `app/router/app_route_table.dart` | 模块注册 + 路由聚合 + 首页 UI |
| `module_registry/module_entry.dart` | ModuleEntry 模型 |
| `module_registry/module_category.dart` | 枚举定义 |
| `modules/<category>/<module>/module_routes.dart` | 模块子路由定义 |

## 关键类

### ModuleEntry (module_registry/module_entry.dart)
模块注册单元，包含：
- `title`: 模块显示名称（中文）
- `path`: 路由路径（kebab-case，如 `/my-module`）
- `subtitle`: 一句话学习收益
- `category`: ModuleCategory（basic/async/state/ui/network）
- `difficulty`: Difficulty（beginner/intermediate/advanced）
- `concepts`: 概念标签列表
- `estimatedMinutes`: 预计学习时间
- `status`: ModuleStatus（pending/ready/recommended）
- `builder`: 模块入口 Widget 构建函数
- `routes`: 子路由列表（`List<GoRoute>`）

### 路由注册流程
1. 模块内创建 `module_routes.dart`，定义 `*Routes` 类
2. `*Routes` 类包含路径常量和 `routes` getter（返回 `List<GoRoute>`）
3. 在 `app/router/app_route_table.dart` 中 import 模块路由
4. 在 `_modules` 列表中注册 `ModuleEntry`，传入 `routes: *Routes.routes`
5. 首页自动按 `category` 分组展示所有模块

## 新增模块路由示例

```dart
// lib/modules/<category>/my_module/module_routes.dart
import 'package:go_router/go_router.dart';
import 'pages/my_sub_page.dart';

class MyModuleRoutes {
  MyModuleRoutes._();

  static const String subPage = '/sub-page';

  static List<GoRoute> get routes => [
        GoRoute(
          path: 'sub-page',
          builder: (_, __) => const MySubPage(),
        ),
      ];
}
```

```dart
// lib/app/router/app_route_table.dart 中注册
import '../../modules/<category>/my_module/module_entry.dart';
import '../../modules/<category>/my_module/module_routes.dart';

final List<ModuleEntry> _modules = [
  ModuleEntry(
    title: '我的模块',
    path: '/my-module',
    subtitle: '一句话说明学习收益',
    category: ModuleCategory.basic,
    difficulty: Difficulty.beginner,
    concepts: ['概念1', '概念2'],
    estimatedMinutes: 20,
    status: ModuleStatus.ready,
    builder: (context) => const MyModuleEntry(),
    routes: MyModuleRoutes.routes,
  ),
  // ...
];
```

## 子路由路径规范

- 子路由 path **不需要**前缀 `/`（go_router 会自动处理）
- 路径使用 kebab-case（如 `sub-page`）
- 路径常量定义在 `*Routes` 类中，便于模块内跳转使用

## 注意事项

- 新增模块须同时 import 入口和路由
- 修改子路由只需改模块内的 `module_routes.dart`，无需触碰 `app_route_table.dart`
- 状态管理模块使用 `AppRoutes.routes` 映射表（`Map<String, WidgetBuilder>`），与其他模块不同
