# AI 模块分析: usb_detector_demo

> 跨平台 USB 设备检测与监控。

## 功能

使用 `usb_serial` 和 `device_info_plus` 包实现 USB 设备检测，周期性扫描设备并通过 Stream 推送设备列表和状态消息。

## 文件结构

```
usb_detector_demo/
├── module_entry.dart                  # 入口: 跳转到 MyHomePage
├── module_root.dart                   # UI: USB 驱动状态 + 设备列表 + 刷新
├── models/
│   └── usb_device_info.dart           # UsbDeviceInfo 模型 + UsbDeviceStatus 枚举
└── services/
    └── usb_detection_service.dart     # 单例服务: USB 初始化 + 周期扫描 + Stream 广播
```

## 核心机制

```
UsbDetectionService.initialize()
  → UsbSerial.setPortHandler()
  → Timer.periodic(3s) 扫描设备
    → _deviceController.add(设备列表)
    → _statusController.add(状态消息)
```

## 数据模型

| 类/枚举 | 字段 |
|--------|------|
| `UsbDeviceInfo` | vendorId, productId, manufacturer, product, serialNumber, status |
| `UsbDeviceStatus` | connected, disconnected, error, unknown |

## Stream 广播

- `_deviceController`: 广播设备列表更新
- `_statusController`: 广播状态消息

## 注意事项

- USB 检测在桌面平台（macOS/Windows）支持较好，移动端受限
- 需要适当的系统权限才能访问 USB 设备

## 修改建议

- 添加设备详情: 点击设备显示详细信息
- 串口通信: 集成 usb_serial 实现数据收发
- 自动连接: 检测到特定设备时自动建立连接
