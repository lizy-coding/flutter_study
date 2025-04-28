# microtask

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Flutter 异步事件循环

### 事件循环概述
- Dart 在主 Isolate 中运行单线程的 Event Loop，包含微任务队列（Microtask Queue）与事件队列（Event Queue）。
- 执行顺序：先执行所有微任务，再执行一个事件，再回到微任务，循环往复。

### 常用调度函数
- `scheduleMicrotask(() { ... })`：将任务加入微任务队列，优先级最高。
- `Timer.run(() { ... })` 或 `Future(() { ... })`：将任务加入事件队列。
- `Future.microtask(() { ... })`：将任务加入微任务队列。
- `Future.value(x).then(...)`：生成已完成的 Future，回调将加入微任务队列。

### 执行示例伪代码
```dart
print("main start");

scheduleMicrotask(() {
  print("微任务 A");
});

Future(() {
  print("事件任务 B");
}).then((_) {
  print("微任务 C");
});

print("main end");

// 输出顺序：
// main start
// main end
// 微任务 A
// 事件任务 B
// 微任务 C
```

### 微任务、事件与主线程关系详解
- **主线程（UI线程）**：负责执行所有 Dart 代码，包括同步任务与调度异步任务（将任务加入队列）。
- **同步任务**：直接在主线程上执行，执行过程中会阻塞后续任务。
- **微任务（Microtask）**：优先级较高，插入微任务队列，执行时机在当前同步代码执行完后、下一个事件处理前。
- **事件（Event）**：包含 Timer、I/O、手势、通过 `Future(() {})` 和 `Timer.run` 等方式调度的任务，这些任务插入事件队列，只有在微任务队列清空后才会执行。
- **执行流程**：
  1. 执行当前同步代码，直到结束或遇到 `await`（遇到 `await` 时同步代码暂停并将后续代码作为微任务）。
  2. 处理所有微任务队列中的任务，直到队列为空。
  3. 从事件队列中取出一个事件任务执行。
  4. 重复步骤 2-3 直至所有任务完成或线程结束。
- **示例时序（伪代码图示）**：

```text
时间轴：        主线程      微任务队列     事件队列
------------------------------------------------------
同步阶段：     A()()          -            -
调度阶段：     schedule(A)  Future(B)      -
执行微任务：    -           执行 A         -
执行事件：     -            -           执行 B
```

## Flutter事件机制示例程序

这个项目是对Flutter异步事件循环机制的实际演示，帮助理解微任务队列和事件队列的工作原理及执行顺序。

### 示例程序功能

1. **基础事件测试**：展示同步代码、微任务和事件任务的基本执行顺序
2. **嵌套事件测试**：展示在事件和微任务中再次调度其他事件和微任务的复杂执行顺序
3. **Future测试**：展示Future链式调用、async/await的执行顺序和微任务装箱机制

### 关键源码实现分析

#### 微任务调度

当调用`scheduleMicrotask()`时，内部会将回调加入Dart微任务队列：

```dart
void scheduleMicrotask(void callback()) {
  _Zone currentZone = Zone.current;
  if (identical(_rootZone, currentZone)) {
    // 在根Zone直接调度
    _rootScheduleMicrotask(null, null, _rootZone, callback);
    return;
  }
  // 使用当前Zone调度
  Zone.current.scheduleMicrotask(
      Zone.current.bindCallbackGuarded(callback));
}
```

#### 事件队列调度

使用`Future()`或`Timer.run()`会将任务加入事件队列：

```dart
factory Future(FutureOr<T> computation()) {
  _Future<T> result = _Future<T>();
  Timer.run(() {
    try {
      result._complete(computation());
    } catch (e, s) {
      _completeWithErrorCallback(result, e, s);
    }
  });
  return result;
}
```

#### 执行顺序规则

1. 先执行同步代码
2. 执行所有微任务队列(Microtask Queue)中的任务，直到队列为空
3. 从事件队列(Event Queue)取出一个任务执行
4. 继续执行微任务队列，然后事件队列，循环往复

这个示例程序通过可视化的方式展示了这一执行过程，并用不同颜色区分不同类型的任务：
- 黑色：同步代码
- 蓝色：微任务
- 红色：事件任务

### 执行结果解读

通过运行示例，可以观察到：
1. 微任务总是在事件任务之前执行
2. 同一队列中的任务按照注册顺序执行
3. 嵌套调度的微任务会在当前事件循环的微任务阶段执行完成
4. Future链中的then回调被装箱为微任务
5. await表达式之后的代码会被转换为微任务
