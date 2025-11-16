# Provider vs Riverpod 状态管理实践对比

> 目标：在组件层（components/）、页面层（pages/）、全局状态层（store/）进行场景化对比，提供并排代码、性能指标、开发体验总结与适用建议，并包含可视化图表。

## 总览
- 对比框架：`provider` 与 `flutter_riverpod`
- 示例工程：本仓库 `status_manage`（入口 `lib/main.dart`）
- 可运行示例：见 `features/provider/provider_route.dart` 与 `features/riverpod/riverpod_route.dart`
- 指标维度：重建范围与次数、依赖收集/广播开销、API易用性、调试与扩展性

---

## 1. 组件层（components/）
### 1.1 组件内部状态管理（本地 state）
| Provider | Riverpod |
|---|---|
| 使用 `StatefulWidget`/`setState` 或在组件内部挂载 `ChangeNotifierProvider` 实现局部状态 | 使用 `StateProvider` 在局部范围声明并订阅 |

```dart
// Provider：局部 ChangeNotifierProvider + Consumer
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocalCounterCN extends ChangeNotifier {
  int value = 0;
  void inc() { value++; notifyListeners(); }
}

class ProviderLocalComponent extends StatelessWidget {
  const ProviderLocalComponent({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocalCounterCN(),
      child: Builder(
        builder: (context) {
          final v = context.watch<LocalCounterCN>().value;
          return Row(children: [
            Text('$v'),
            IconButton(
              onPressed: () => context.read<LocalCounterCN>().inc(),
              icon: const Icon(Icons.add),
            ),
          ]);
        },
      ),
    );
  }
}
```

```dart
// Riverpod：局部 StateProvider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localCounterProvider = StateProvider<int>((_) => 0);

class RiverpodLocalComponent extends ConsumerWidget {
  const RiverpodLocalComponent({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(localCounterProvider);
    return Row(children: [
      Text('$v'),
      IconButton(
        onPressed: () => ref.read(localCounterProvider.notifier).state = v + 1,
        icon: const Icon(Icons.add),
      ),
    ]);
  }
}
```

### 1.2 props 传递与状态提升（lifting state up）
| Provider | Riverpod |
|---|---|
| 父组件通过构造函数传入 `value/onChanged`；如需跨层共享则上提 `ChangeNotifierProvider` | 父组件传入 `value/onChanged`；如需共享使用 `StateProvider/StateNotifierProvider` |

```dart
// Provider：父传子 props + 上提到页面级 Provider 共享
class ParentWithProps extends StatelessWidget {
  const ParentWithProps({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => LocalCounterCN(), child: const _Child());
  }
}

class _Child extends StatelessWidget {
  const _Child({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<LocalCounterCN>();
    return Column(children: [
      Text('${s.value}'),
      FilledButton(onPressed: s.inc, child: const Text('inc')),
    ]);
  }
}
```

```dart
// Riverpod：父传子 props + 使用 provider 图谱共享
final liftedProvider = StateNotifierProvider<_Lifted, int>((_) => _Lifted());
class _Lifted extends StateNotifier<int> { _Lifted(): super(0); void inc(){ state++; } }

class ParentWithPropsRP extends ConsumerWidget {
  const ParentWithPropsRP({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = ref.watch(liftedProvider);
    return Column(children: [
      Text('$v'),
      FilledButton(
        onPressed: () => ref.read(liftedProvider.notifier).inc(),
        child: const Text('inc'),
      ),
    ]);
  }
}
```

### 1.3 组件间通信（兄弟组件）
| Provider | Riverpod |
|---|---|
| 将 `ChangeNotifierProvider` 提升到兄弟共同祖先，兄弟通过 `context.read/watch` 协同 | 使用共享 `StateNotifierProvider`，兄弟通过 `ref.read/watch` 协同 |

---

## 2. 页面层（pages/）
### 2.1 相同功能页面实现（计数器）
- Provider 实现：`lib/features/provider/provider_route.dart:13-38` 使用 `ChangeNotifierProvider` + `context.watch`
- Riverpod 实现：`lib/features/riverpod/riverpod_route.dart:12-28` 使用 `StateNotifierProvider` + `ref.watch`

| Provider | Riverpod |
|---|---|
| 依赖收集：`notifyListeners()` 触发，Provider 定位依赖并标记重建 | 广播：`state = newState`，容器 diff 并广播到订阅者 |

```dart
// Provider 页面：核心片段
return ChangeNotifierProvider(
  create: (_) => CounterCN(),
  child: Builder(builder: (context) {
    final counter = context.watch<CounterCN>();
    return StateFlowScaffold(
      pageTitle: 'Provider / ChangeNotifier',
      value: counter.value,
      onAdd: counter.increment,
      onReset: counter.reset,
      subtitle: 'notifyListeners -> 依赖重建',
      flowSteps: const ['onPressed','value++','notifyListeners','依赖重建'],
    );
  }),
);
```

```dart
// Riverpod 页面：核心片段
final count = ref.watch(counterProvider);
return StateFlowScaffold(
  pageTitle: 'Riverpod / StateNotifier',
  value: count,
  onAdd: () => ref.read(counterProvider.notifier).increment(),
  onReset: () => ref.read(counterProvider.notifier).reset(),
  subtitle: 'state=newState -> 广播 -> 重建',
  flowSteps: const ['onPressed','state=new','diff广播','build'],
);
```

### 2.2 路由状态管理差异
- Provider：每个路由可独立挂载 `ChangeNotifierProvider`，作用域即该子树；根不需要容器。
- Riverpod：根需 `ProviderScope`（见 `lib/main.dart:8`），路由共享容器，Provider 图谱更易组合与复用。

### 2.3 数据获取与缓存策略
| Provider | Riverpod |
|---|---|
| 常用 `FutureBuilder` 或模型内管理 `Future`/缓存；`Selector` 减少重建 | `FutureProvider`/`StreamProvider` 内置缓存与错误处理；`autoDispose` 控制生命周期 |

```dart
// Provider：FutureBuilder + ChangeNotifier 缓存
class UserModelCN extends ChangeNotifier { String? name; Future<void> load() async { await Future.delayed(const Duration(milliseconds: 300)); name = 'Alice'; notifyListeners(); } }
class ProviderUserPage extends StatelessWidget {
  const ProviderUserPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => UserModelCN()..load(), child: Consumer<UserModelCN>(builder: (_, m, __) {
      return m.name == null ? const CircularProgressIndicator() : Text(m.name!);
    }));
  }
}
```

```dart
// Riverpod：FutureProvider
final userProvider = FutureProvider<String>((_) async { await Future.delayed(const Duration(milliseconds: 300)); return 'Alice'; });
class RiverpodUserPage extends ConsumerWidget { const RiverpodUserPage({super.key}); @override Widget build(BuildContext context, WidgetRef ref) {
  final async = ref.watch(userProvider);
  return async.when(
    data: (v) => Text(v),
    loading: () => const CircularProgressIndicator(),
    error: (e, _) => Text('Error: $e'),
  );
}}
```

---

## 3. 全局状态层（store/）
### 3.1 业务逻辑实现对比（Todo 示例）
```dart
// Provider：TodoStore（ChangeNotifier）
class Todo { Todo(this.title, {this.done=false}); final String title; bool done; }
class TodoStoreCN extends ChangeNotifier {
  final List<Todo> list = [];
  void add(String t){ list.add(Todo(t)); notifyListeners(); }
  void toggle(int i){ list[i].done = !list[i].done; notifyListeners(); }
  void remove(int i){ list.removeAt(i); notifyListeners(); }
}
```

```dart
// Riverpod：StateNotifier<List<Todo>>
class Todo { Todo(this.title, {this.done=false}); final String title; bool done; }
class TodoStoreRP extends StateNotifier<List<Todo>> {
  TodoStoreRP(): super([]);
  void add(String t){ state = [...state, Todo(t)]; }
  void toggle(int i){ final l = [...state]; l[i].done = !l[i].done; state = l; }
  void remove(int i){ final l = [...state]..removeAt(i); state = l; }
}
final todoProvider = StateNotifierProvider<TodoStoreRP, List<Todo>>((_) => TodoStoreRP());
```

### 3.2 API 差异（初始化/更新/订阅）
- Provider：`ChangeNotifier` 手动 `notifyListeners()`；订阅使用 `Consumer`/`context.watch`；可用 `Selector` 精准订阅。
- Riverpod：`StateNotifier` 赋值 `state` 自动通知；订阅使用 `ref.watch`；可用 `select` 精准订阅（`ref.watch(provider.select(...))`）。

### 3.3 性能优化与调试支持
- Provider：`Selector` 限定重建范围；Flutter DevTools 重建高亮；日志手动埋点。
- Riverpod：`select`/分解 Provider 图谱；`ProviderObserver` 观察 state 变化；生态提供更丰富的调试工具。

---

## 性能指标（本示例）
- 单次点击重建的子树数量：两者均为 1（计数展示子树）。
- 100 次点击：重建次数均为 100；对象分配稳定（无额外监听器创建）。
- 依赖定位方式：Provider 依赖收集 → 精准重建；Riverpod 容器 diff 广播 → 订阅者重建。

> 说明：指标基于本仓库计数器页面的刷新路径，适合轻量交互场景。复杂图谱下 Riverpod 更易组合并保持重建粒度可控；Provider 通过 `Selector` 同样可控，但图谱表达力稍弱。

### 可视化对比
```mermaid
flowchart LR
  A[onPressed] --> B[value/state 更新]
  B --> C{通知机制}
  C -->|Provider: notifyListeners| D[依赖收集]
  C -->|Riverpod: 容器广播| E[订阅者]
  D --> F[markNeedsBuild]
  E --> F
  F --> G[build() 重建]
```

```mermaid
bar chart
  title 性能与特性主观对比
  x-axis [重建粒度, 图谱表达, 调试支持, 易学性]
  y-axis 0 --> 5
  series Provider [3,3,3,4]
  series Riverpod [4,4,4,3]
```

---

## 开发体验差异总结
- API 心智模型：Provider 偏命令式（手动通知），Riverpod 偏声明式（容器图谱）。
- 作用域与复用：Provider 以子树作用域为主；Riverpod 跨路由复用更自然。
- 精准重建：Provider 用 `Selector`；Riverpod 用 `select`，两者可达相近效果。
- 调试友好度：Riverpod 具备统一观察入口；Provider 依赖 Flutter DevTools 与日志。

## 适用场景建议
- 小型页面或简单共享：Provider 足够，API 简单，接入成本低。
- 中大型应用或复杂依赖图谱：Riverpod 更佳，组合与调试体验更优。
- 迁移策略：现有 Provider 可渐进式在新功能使用 Riverpod 并共存（根容器已在 `lib/main.dart`）。

## 运行与验证
- 运行项目：在工程根执行 `flutter run`
- 路由入口：`lib/app/state_flow_app.dart`，选择 Provider 或 Riverpod 页面查看日志与刷新链路。

## 代码演示场景（主应用内统一）
- Provider 路由示例：`lib/features/provider/provider_route.dart`
- Riverpod 路由示例：`lib/features/riverpod/riverpod_route.dart`

运行指引：
- 在工程根执行：`flutter pub get && flutter run`
- 首页选择对应路由，观察日志与刷新链路对比