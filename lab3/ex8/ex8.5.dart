// Problem 8.7

class DeviceConfig {
  final String id;
  final int maxConnections;
  final bool debugMode;

  const DeviceConfig({
    required this.id,
    this.maxConnections = 10,
    this.debugMode = false,
  });
}

class Device {
  final DeviceConfig config;

  const Device(this.config);

  void status() => print('Device ${config.id}: '
      'max ${config.maxConnections} connections, debug=${config.debugMode}');
}

class NetworkDevice extends Device {
  final String ipAddress;

  const NetworkDevice(super.config, this.ipAddress);

  @override
  void status() {
    super.status();
    print('  IP address: $ipAddress');
  }
}

class Router extends NetworkDevice {
  final int ports;

  // Config passed up the chain
  const Router(super.config, super.ipAddress, this.ports);

  @override
  void status() {
    super.status();
    print('  Ports: $ports');
  }
}

void main() {
  const DeviceConfig config = DeviceConfig(id: 'RTR-001', maxConnections: 50);

  const Router router = Router(config, '192.168.1.1', 8);
  router.status();
}
