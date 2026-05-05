# AI 模块分析: flutter_ioc

> 自研 IoC 容器实现，支持依赖注入模式。

## 功能

实现了一个功能完整的 IoC 容器，支持多种生命周期、条件注册、属性注入、作用域嵌套。

## 文件结构

```
flutter_ioc/
├── module_entry.dart          # 入口: 创建容器，注册 CounterModel 单例
├── module_root.dart           # CounterScreen: 显示计数和名称
├── ioc/
│   ├── ioc.dart               # Barrel export
│   ├── container.dart         # IoC 容器完整实现
│   └── types.dart             # 类型定义: Lifetime, Factory, IoCContainer 接口
└── model/
    └── counter_model.dart     # ChangeNotifier: count + name 状态
```

## IoC 容器特性

| 特性 | 说明 |
|------|------|
| Singleton | 单例生命周期，全局共享实例 |
| Transient | 每次解析创建新实例 |
| Scoped | 作用域生命周期，同一作用域内共享 |
| 条件注册 | 根据条件决定是否注册 |
| 属性注入 | 自动注入对象的属性 |
| 作用域嵌套 | 父子作用域，子作用域可覆盖父作用域的注册 |
| 循环依赖检测 | 检测并报告循环依赖 |

## 关键接口 (types.dart)

```dart
enum Lifetime { singleton, transient, scoped }
typedef Factory<T> = T Function();
typedef Condition = bool Function();
typedef PropertyInjector = void Function(Object instance);

abstract class IoCContainer {
  void register<T>(Factory<T> factory, {Lifetime lifetime});
  T resolve<T>();
  IoCContainer createScope();
}
```

## 修改建议

- 添加新服务: 在 module_entry.dart 中注册到容器
- 测试容器: 扩展 test/ioc_container_test.dart
- 集成其他状态管理: 将 IoC 容器与 Provider/Riverpod 结合
