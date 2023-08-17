import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/models/device.dart';
import 'package:hive/hive.dart';

abstract class DeviceRepository {
  Map<dynamic, Device> getAllDevices();

  void addDevice(Device device);

  void updateDevice(MapEntry<dynamic, Device> entry);

  MapEntry<dynamic, Device>? getActiveDevice();

  void activateDeviceWithKey(dynamic key);

  void activateLatestDevice();

  List<Alarm> getAlarmsForActiveDevice();

  void addAlarmForActiveDevice(Alarm alarm);
}
