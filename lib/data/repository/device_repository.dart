import 'package:ch600/data/models/device.dart';

abstract class DeviceRepository {
  Map<dynamic, Device> getAllDevices();

  void addDevice(Device device);

  void updateDevice(MapEntry<dynamic, Device> entry);

  MapEntry<dynamic, Device>? getActiveDevice();

  void activateDeviceWithKey(dynamic key);

  void activateLatestDevice();
}
