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
├── main.dart                      # 仅负责挂 ProviderScope 与 StateFlowApp
├── app/state_flow_app.dart        # MaterialApp + 首页卡片导航
├── features/
│   ├── provider/provider_route.dart   # ChangeNotifier 流程
│   └── riverpod/riverpod_route.dart   # StateNotifier / Riverpod 流程
└── shared/widgets/state_flow_scaffold.dart # 统一 UI、动画、时间轴
```

- `StateFlowHome` 使用卡片描述每条刷新链路，并跳转到对应示例路由。
- 每个示例页面都调用 `debugPrint` 输出「事件 → 状态 → 通知 → build」关键日志，可与 UI 动效对照理解刷新流。
- `StateFlowScaffold` 加入 `AnimatedSwitcher`、`AnimatedContainer` 与步骤时间轴，帮助观察状态变化节奏。

## 学习建议

1. **阅读首页卡片**：先理解 Provider / Riverpod 的链路文字描述，再进入路由体验。
2. **触发按钮事件**：在页面内点击 “加 1 / 重置”，观察数值动画和时间轴变化。
3. **查看控制台日志**：结合 `debugPrint` 输出，核对每一步到底发生了什么。
4. **扩展练习**：可以按照同样的结构新增 Bloc 等路由，只需实现对应的 `flowSteps` 与状态模型。

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
