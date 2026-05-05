# AI 模块分析: stream_subscription

> Dart/Flutter Stream 完整学习示例：单订阅 vs 广播流。

## 功能

演示单订阅流和广播流的使用，包括暂停/恢复/取消操作以及流变换工具函数。

## 文件结构

```
stream_subscription/
├── module_entry.dart              # 入口: 跳转到 HomePage
├── pages/
│   ├── home_page.dart             # 仪表盘: 导航到各演示页
│   ├── stream_demo_page.dart      # 单订阅流演示
│   ├── stream_demo_controller.dart # 单订阅流控制器
│   └── broadcast_demo/
│       └── broadcast_demo_page.dart # 广播流演示（多监听器）
├── services/
│   └── stream_service.dart        # 单例服务: 管理两种 StreamController
├── utils/
│   └── stream_utils.dart          # 流工具函数
└── models/
    └── message_model.dart         # 消息模型
```

## Stream 类型

| 类型 | 特点 | 使用场景 |
|------|------|---------|
| 单订阅流 | 只能有一个监听器 | HTTP 响应、文件读取 |
| 广播流 | 可以有多个监听器 | 事件总线、状态通知 |

## StreamController 生命周期回调

- `onListen`: 第一个监听器添加时
- `onPause`: 流被暂停时
- `onResume`: 流被恢复时
- `onCancel`: 最后一个监听器移除时

## 修改建议

- 添加流变换: 演示 map、where、expand、take 等操作符
- 错误处理: 添加 stream.handleError 示例
- RxDart 集成: 引入 RxDart 展示 BehaviorSubject、PublishSubject
