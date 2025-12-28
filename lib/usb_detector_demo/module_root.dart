import 'package:flutter/material.dart';

import 'models/usb_device_info.dart';
import 'services/usb_detection_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final UsbDetectionService _usbService = UsbDetectionService();
  List<UsbDeviceInfo> _devices = [];
  String _statusMessage = '正在初始化...';
  String _systemInfo = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeUsb();
  }

  @override
  void dispose() {
    _usbService.dispose();
    super.dispose();
  }

  Future<void> _initializeUsb() async {
    bool initialized = await _usbService.initialize();
    String systemInfo = await _usbService.getSystemInfo();

    setState(() {
      _isInitialized = initialized;
      _systemInfo = systemInfo;
    });

    _usbService.deviceStream.listen((devices) {
      setState(() {
        _devices = devices;
      });
    });

    _usbService.statusStream.listen((status) {
      setState(() {
        _statusMessage = status;
      });
    });
  }

  Future<void> _refreshDevices() async {
    await _usbService.refreshDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDevices,
            tooltip: '刷新设备列表',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isInitialized ? Icons.check_circle : Icons.error_outline,
                          color: _isInitialized ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'USB驱动状态',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_usbService.systemStatus),
                    const SizedBox(height: 4),
                    Text(
                      _statusMessage,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (_systemInfo.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        _systemInfo,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'USB设备列表 (${_devices.length})',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _devices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.usb_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isInitialized ? '未检测到USB设备' : 'USB服务未初始化',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        final device = _devices[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              _getDeviceIcon(device.status),
                              color: _getStatusColor(device.status),
                            ),
                            title: Text(device.displayName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('设备ID: ${device.deviceId}'),
                                if (device.manufacturer != null)
                                  Text('制造商: ${device.manufacturer}'),
                                if (device.serialNumber != null)
                                  Text('序列号: ${device.serialNumber}'),
                                Text('状态: ${device.status.displayName}'),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(device.status).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getStatusColor(device.status),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                device.status.displayName,
                                style: TextStyle(
                                  color: _getStatusColor(device.status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshDevices,
        tooltip: '刷新设备',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  IconData _getDeviceIcon(UsbDeviceStatus status) {
    switch (status) {
      case UsbDeviceStatus.connected:
        return Icons.usb;
      case UsbDeviceStatus.disconnected:
        return Icons.usb_off;
      case UsbDeviceStatus.error:
        return Icons.error;
      case UsbDeviceStatus.unknown:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(UsbDeviceStatus status) {
    switch (status) {
      case UsbDeviceStatus.connected:
        return Colors.green;
      case UsbDeviceStatus.disconnected:
        return Colors.grey;
      case UsbDeviceStatus.error:
        return Colors.red;
      case UsbDeviceStatus.unknown:
        return Colors.orange;
    }
  }
}
