```text
状态管理本质：状态变化 → 通知机制 → UI rebuild

├── 原生 setState
│   └── 手动管理、同步刷新、局部有效
│
├── Provider
│   ├── 封装 InheritedWidget
│   ├── 依赖 context
│   └── ChangeNotifier 通知重建
│
├── Riverpod
│   ├── 容器化管理 Provider
│   ├── 无需 context，自动依赖追踪
│   └── 统一状态源、可测试
│
└── Bloc
    ├── 事件流驱动（Event → State）
    ├── 基于 StreamController
    └── 明确逻辑分层，适合大型架构

```


```xml
┌──────────────────────────────────────────────────────────────┐
│                        Flutter 状态管理演进                  │
└──────────────────────────────────────────────────────────────┘

                    ┌──────────────────────┐
                    │  ① setState（原生） │
                    └──────────────────────┘
                               │
                状态存在组件内部 → 手动 setState() → markNeedsBuild()
                               │
                               ▼
         ┌───────────────────────────────────────┐
         │ UI 与状态绑定紧密，局部刷新简单直接。 │
         └───────────────────────────────────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  ② Provider 层级共享 │
                    └──────────────────────┘
                               │
          基于 InheritedWidget + ChangeNotifier 实现依赖追踪
          状态集中在 Model，通过 notifyListeners() 通知 UI rebuild
                               │
                               ▼
     ┌──────────────────────────────────────────────────────────────┐
     │ 优点：跨组件共享，逻辑复用简单；缺点：依赖 context，测试困难。 │
     └──────────────────────────────────────────────────────────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  ③ Riverpod 容器化   │
                    └──────────────────────┘
                               │
             ProviderContainer 统一管理状态依赖关系
            watch() 自动追踪依赖，state 改变 → 自动重建
                               │
                               ▼
     ┌──────────────────────────────────────────────────────────────┐
     │ 优点：脱离 Widget 树，无 context 依赖；可测试、可组合。       │
     │ 缺点：学习曲线高，概念多（Ref/Provider/Notifier）。         │
     └──────────────────────────────────────────────────────────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  ④ Bloc 事件驱动模式 │
                    └──────────────────────┘
                               │
              Event → Bloc.mapEventToState() → emit(State)
              → StreamController → BlocBuilder rebuild
                               │
                               ▼
     ┌──────────────────────────────────────────────────────────────┐
     │ 优点：事件流清晰，逻辑可追踪，适合大型项目；                 │
     │ 缺点：模板代码多，开发初期复杂度高。                         │
     └──────────────────────────────────────────────────────────────┘


┌──────────────────────────────────────────────────────────────┐
│                       统一原理（核心本质）                    │
└──────────────────────────────────────────────────────────────┘

   状态变化 (State Mutation)
            ↓
   通知监听者 (Observer / Stream / Container)
            ↓
   调用 markNeedsBuild() 标记 Element 脏
            ↓
   Flutter 下一帧 build() → diff → layout → paint
            ↓
   UI 更新（重绘）

★ 不论使用何种框架，本质都是同一条链路。

---

## 项目分层 & 路由

```text
lib/
├── main.dart                              # 仅负责挂 ProviderScope 与 StateFlowApp
├── app/state_flow_app.dart                # MaterialApp + 首页卡片导航
├── app/app_routes.dart                    # 集中路由映射
├── app/route_paths.dart                   # 统一路由常量
├── features/
│   ├── provider/                          # Provider 场景
│   │   ├── provider_route.dart            # 基础计数器 + 深层叶子直取祖先状态 + Selector 粒度刷新
│   │   ├── provider_lifting_route.dart    # 状态提升与共享
│   │   ├── provider_future_route.dart     # 数据获取与缓存
│   │   └── provider_todo_route.dart       # 全局 Todo 示例
│   ├── riverpod/                          # Riverpod 场景
│   │   ├── riverpod_route.dart            # 基础计数器
│   │   ├── riverpod_lifting_route.dart    # 状态提升与共享
│   │   ├── riverpod_future_route.dart     # 数据获取与缓存
│   │   └── riverpod_todo_route.dart       # 全局 Todo 示例
│   └── bloc/                              # Bloc 场景（新增）
│       ├── counter_event.dart             # 事件定义
│       ├── counter_state.dart             # 状态定义
│       ├── counter_bloc.dart              # 业务逻辑层
│       └── bloc_route.dart                # UI 展示与绑定
└── shared/widgets/state_flow_scaffold.dart# 统一 UI、动画、时间轴
```

- `StateFlowHome` 使用卡片描述每条刷新链路，并跳转到对应示例路由。
- 每个示例页面都调用 `debugPrint` 输出「事件 → 状态 → 通知 → build」关键日志，可与 UI 动效对照理解刷新流。
- `StateFlowScaffold` 加入 `AnimatedSwitcher`、`AnimatedContainer` 与步骤时间轴，帮助观察状态变化节奏。
- Provider 基础示例增加「深层叶子」与「粒度刷新」区块：最深层 Widget 直接 `context.read/select` 祖先状态，无需 props 传递；`Selector/context.select` 将重建范围锁定在监听字段，配合控制台日志可观察哪些 Widget 被重建。

## 学习建议

1. **阅读首页卡片**：先理解 Provider / Riverpod 的链路文字描述，再进入路由体验。
2. **触发按钮事件**：在页面内点击 “加 1 / 重置”，观察数值动画和时间轴变化。
3. **查看控制台日志**：结合 `debugPrint` 输出，核对每一步到底发生了什么。
4. **扩展练习**：本项目已新增 Bloc 路由（`lib/features/bloc/bloc_route.dart`），对比 Provider 与 Riverpod 的刷新链路与 API 差异。

## 运行

```bash
# 在可执行 Flutter 命令的终端中（Windows PowerShell / CMD）
flutter pub get
flutter run -d chrome          # 或选择其它可用设备

# 如需静态检查
flutter analyze
```

> 如果在 WSL 中运行 `flutter` 出现 `'/usr/bin/env: bash\r'` 报错，说明当前使用的是 Windows 发行版的 Flutter，可改在 Windows 终端执行或将脚本行结尾转换为 LF。
```
## Bloc 示例说明

- 入口路由：`lib/features/bloc/bloc_route.dart`
- 事件与状态：`lib/features/bloc/counter_event.dart`、`lib/features/bloc/counter_state.dart`
- 业务逻辑：`lib/features/bloc/counter_bloc.dart`
- 测试用例：`test/bloc_counter_test.dart`

运行交互：在 Bloc 页面点击“加 1 / 重置”，控制台与 UI 将展示 “add(Event) → Bloc 处理 → emit(State) → BlocBuilder 重建” 的完整链路。
- Provider 模型抽离与颗粒度订阅：
  - 模型接口：`lib/features/provider/models/counter_model.dart`
  - 具体实现：`lib/features/provider/models/counter_cn.dart`
  - 视图层示例：`lib/features/provider/provider_route.dart`、`lib/features/provider/widgets/provider_perks.dart`、`lib/features/provider/widgets/granular_grid.dart`
  - 单元测试：`test/provider_counter_test.dart`
