# AI 模块分析: status_manage

> 状态管理完整对比：Provider、Riverpod、Bloc。

## 功能

通过并行的四个演示场景（基础计数、状态提升、Future 数据获取、全局 Todo），对比三种主流状态管理方案的实现差异。

## 文件结构

```
status_manage/
├── module_entry.dart              # 入口: 跳转到 StateFlowHome
├── app/
│   ├── state_flow_app.dart        # MaterialApp + 路由注册 + 首页仪表盘
│   ├── app_routes.dart            # 路由声明
│   └── route_paths.dart           # 路由路径常量
├── features/
│   ├── provider/                  # Provider 实现
│   │   ├── provider_route.dart             # 基础计数
│   │   ├── provider_lifting_route.dart     # 状态提升
│   │   ├── provider_future_route.dart      # FutureProvider
│   │   ├── provider_todo_route.dart        # 全局 Todo
│   │   ├── models/
│   │   │   ├── counter_model.dart          # CounterModel 接口
│   │   │   └── counter_cn.dart             # CounterCN 实现 (ChangeNotifier)
│   │   └── widgets/
│   │       └── granular_grid.dart          # 精细刷新网格
│   ├── riverpod/                  # Riverpod 实现
│   │   ├── riverpod_route.dart             # StateNotifier 基础
│   │   ├── riverpod_lifting_route.dart     # 状态提升
│   │   ├── riverpod_future_route.dart      # FutureProvider + when()
│   │   └── riverpod_todo_route.dart        # 全局 Todo
│   └── bloc/                      # Bloc 实现
│       ├── bloc_route.dart                 # 路由
│       ├── counter_bloc.dart               # CounterBloc
│       ├── counter_event.dart              # CounterEvent
│       └── counter_state.dart              # CounterState
└── shared/
    └── widgets/
        └── state_flow_scaffold.dart # 共享脚手架 Widget
```

## 演示场景对比

| 场景 | Provider | Riverpod | Bloc |
|------|---------|---------|------|
| 基础计数 | ChangeNotifierProvider | StateNotifierProvider | CounterBloc |
| 状态提升 | 多层 Provider 传递 | ref.watch 跨层访问 | BlocProvider 传递 |
| Future 数据 | FutureProvider | FutureProvider | Bloc + async 事件 |
| 全局 Todo | 顶层 Provider | 全局 Provider | 顶层 BlocProvider |

## 修改建议

- 添加新状态管理方案: 如 GetX、MobX，在 features/ 下新建目录
- 扩展演示场景: 添加表单验证、嵌套状态等
- 性能对比: 添加重建次数统计和性能指标
