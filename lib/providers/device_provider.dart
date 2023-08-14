import 'package:ch600/models/device.dart';
import 'package:ch600/repository/device_repository.dart';
import 'package:ch600/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

var deviceRepositoryProvider = Provider((ref) => HiveDeviceRepository());

class HiveDeviceRepository extends DeviceRepository {
  late Box<Device> _deviceBox;

  HiveDeviceRepository() {
    _deviceBox = Hive.box<Device>(deviceDB);
  }

  @override
  Map<dynamic, Device> getAllDevices() {
    return _deviceBox.toMap();
  }

  @override
  void addDevice(Device device) {
    _deviceBox.add(device);
  }

  @override
  Device? getActiveDevice() {
    try {
      return _deviceBox.values.firstWhere((element) => element.isActive);
    } catch (_) {
      return null;
    }
  }

  @override
  void activateDeviceWithKey(dynamic key) {
    Device? activeDevice = _deviceBox.get(key);
    if (activeDevice == null) return;
    activeDevice.isActive = true;
    _deviceBox.put(key, activeDevice);
  }

  @override
  void activateLatestDevice() {
    dynamic latestDeviceKey = _deviceBox.keys.last;
    var latestDevice = _deviceBox.get(latestDeviceKey);
    if (latestDevice == null) return;
    latestDevice.isActive = true;
    _deviceBox.put(latestDeviceKey, latestDevice);
  }


}
