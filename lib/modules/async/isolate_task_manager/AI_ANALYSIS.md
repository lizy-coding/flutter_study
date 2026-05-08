# AI 模块分析: isolate_task_manager

> 多任务并行处理，使用 Isolate + Stream 实现进度上报。

## 功能

演示如何在多个 Isolate 中并行执行任务，通过 Stream 实时上报进度，支持暂停/恢复/停止操作。

## 文件结构

```
modules/async/isolate_task_manager/
├── module_entry.dart          # 入口: 显示 MultiTaskIsolatePage
├── module_root.dart           # UI: 任务管理（添加/暂停/恢复/停止 + 进度条）
└── task_manager.dart          # Task 模型 + TaskManager 实现
```

## 核心机制

```
TaskManager.spawnTask()
  → Isolate.spawn(_taskWorker)
    → ReceivePort 接收进度消息
      → StreamController 转发到 UI
        → ProgressStream 更新进度条
```

## 关键类

| 类 | 作用 |
|---|------|
| `Task` | 任务模型，持有 isolate、receivePort、subscription |
| `TaskManager` | 任务管理器: spawn/pause/resume/stop |

## 通信方式

- 主线程 → Isolate: `SendPort.send()` 发送控制命令（pause/resume/stop）
- Isolate → 主线程: `ReceivePort` 接收进度更新（percentage, status）

## 修改建议

- 添加任务优先级: 在 Task 模型中增加 priority 字段
- 任务队列: 实现任务排队执行，限制并发数量
- 结果缓存: 缓存已完成任务的结果
