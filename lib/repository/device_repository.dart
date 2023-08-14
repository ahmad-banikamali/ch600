import 'package:ch600/models/device.dart';

abstract class DeviceRepository {
  Map<dynamic, Device> getAllDevices();

  void addDevice(Device device);

  Device? getActiveDevice();

  void activateDeviceWithKey(dynamic key);

  void activateLatestDevice();
}
