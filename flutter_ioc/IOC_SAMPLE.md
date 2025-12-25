# IoC 示例使用说明

本示例提供了一个轻量级 Dart IoC 容器，支持生命周期管理、构造/属性注入、命名与条件注册、作用域与异步解析等特性。核心代码位于 `lib/ioc/`，测试用例位于 `test/ioc_container_test.dart`。

## 快速开始
```dart
import 'package:flutter_ioc/ioc/ioc.dart';

final container = Container(environment: {'useMock': true, 'baseUrl': 'https://api.local'});

// 注册服务
container
  ..registerSingleton<ApiClient>((r) => ApiClient(r.env('baseUrl') as String))
  ..registerTransient<Repository>((r) => Repository(r.resolve<ApiClient>()))
  ..registerScoped<Logger>((_) => Logger('scoped-logger'))
  ..registerSingleton<Repository>(
    (r) => MockRepository(r.resolve<ApiClient>()),
    condition: (r) => r.flag('useMock'),
  )
  ..registerTransient<NeedsProperty>(
    (_) => NeedsProperty(),
    propertyInjectors: [
      (instance, r) => instance.injectedValue = r.resolve<Logger>().label,
    ],
  );

// 解析实例（构造函数注入通过工厂回调完成）
final repo = container.resolve<Repository>();
final logger = container.createScope().resolve<Logger>(); // 同一 scope 内保持单例
final asyncService = await container.resolveAsync<AsyncService>();
```

## 核心特性
- **生命周期**：`registerSingleton`、`registerTransient`、`registerScoped` 覆盖单例、瞬态与作用域实例。
- **依赖解析**：`resolve<T>` / `resolveAsync<T>` 支持同步与异步工厂；循环依赖会抛出 `ContainerException`。
- **命名与条件注册**：`name` 可区分不同实现；`condition` 基于运行时环境(`env`/`flag`)决定注入实现。
- **构造函数与属性注入**：在工厂回调中使用 `resolver.resolve<T>()` 完成构造注入；`propertyInjectors` 支持创建后设置依赖。
- **自动注册**：实现 `AutoRegistrar`，调用 `container.autoRegister([YourModule()])` 批量注册。
- **作用域与上下文**：`createScope` 创建隔离的作用域缓存；`environmentOverrides` 可在子作用域中覆写配置。

## 运行测试与性能建议
- 执行 `flutter test test/ioc_container_test.dart` 验证核心功能。
- 优先使用单例或作用域实例缓存重用对象；仅在需要新实例时使用瞬态生命周期。
- 将长耗时依赖注册为异步工厂，调用方使用 `resolveAsync` 避免阻塞 UI。
