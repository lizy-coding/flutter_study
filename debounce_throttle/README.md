# debounce_throttle

```mermaid
sequenceDiagram
    participant User
    participant Throttle
    participant Function
    User->>Throttle: 触发事件
    Throttle->>Function: 检查时间间隔
    Throttle->>Function: 达到间隔，执行函数
    User->>Throttle: 再次触发事件
    Throttle->>Function: 未达间隔，忽略
    User->>Throttle: 再次触发事件
    Throttle->>Function: 未达间隔，忽略
    Note over Throttle,Function: 达到时间间隔
    Throttle->>Function: 达到间隔，执行函数
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
