import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

var deviceRepositoryProvider = Provider((ref) => HiveDeviceRepository());

class HiveDeviceRepository extends DeviceRepository {
  late Box<Device> _deviceBox;

  HiveDeviceRepository() {
    _deviceBox = Hive.box<Device>(DbConstants.deviceDB);
  }

  @override
  Map<dynamic, Device> getAllDevices() {
    return _deviceBox.toMap();
  }

  @override
  void addDevice(Device device) {
    _deviceBox.add(device);
    if(_deviceBox.length==1) {
      activateDeviceWithKey(device.key);
    }
  }

  @override
  void updateDevice(MapEntry<dynamic, Device>? oldDevice,
      MapEntry<dynamic, Device> newDevice) {
    if (oldDevice == null) {
      addDevice(newDevice.value);
    } else {
      refreshOldDevice(oldDevice.value, newDevice.value);
      _deviceBox.put(oldDevice.key, oldDevice.value);
    }
  }

  void refreshOldDevice(Device oldDevice, Device newDevice) {
    oldDevice.name = newDevice.name;
    oldDevice.password = newDevice.password;
    oldDevice.defaultSimCard = newDevice.defaultSimCard;
    oldDevice.phone = newDevice.phone;
  }

  @override
  MapEntry<dynamic, Device>? getActiveDevice() {
    try {
      var firstWhere = _deviceBox
          .toMap()
          .entries
          .firstWhere((element) => element.value.isActive);
      return firstWhere;
    } catch (_) {
      return null;
    }
  }

  @override
  void activateDeviceWithKey(dynamic key) {
    Device? activeDevice = _deviceBox.get(key);
    if (activeDevice == null) return;
    deactivateAllDevices();
    activeDevice.isActive = true;
    _deviceBox.put(key, activeDevice);
  }

  @override
  void activateLatestDevice() {
    dynamic latestDeviceKey = _deviceBox.keys.last;
    var latestDevice = _deviceBox.get(latestDeviceKey);
    if (latestDevice == null) return;
    deactivateAllDevices();
    latestDevice.isActive = true;
    _deviceBox.put(latestDeviceKey, latestDevice);
  }

  void deactivateAllDevices() {
    _deviceBox.toMap().entries.forEach((element) {
      element.value.isActive = false;
      _deviceBox.put(element.key, element.value);
    });
  }
}
