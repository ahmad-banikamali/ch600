import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

var deviceRepositoryProvider = Provider((ref) => HiveDeviceRepository());

class HiveDeviceRepository extends DeviceRepository {
  late Box<Device> _deviceBox;
  late Box<Alarm> _alarmBox;

  HiveDeviceRepository() {
    _deviceBox = Hive.box<Device>(deviceDB);
    _alarmBox = Hive.box<Alarm>(alarmDB);
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
  void updateDevice(MapEntry<dynamic, Device> entry) {
    if (entry.key == null) {
      addDevice(entry.value);
    } else {
      _deviceBox.put(entry.key, entry.value);
    }
  }

  @override
  MapEntry<dynamic, Device>? getActiveDevice() {
    try {
      return _deviceBox
          .toMap()
          .entries
          .firstWhere((element) => element.value.isActive);
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

  @override
  List<Alarm> getAlarmsForActiveDevice() {
    var device = getActiveDevice();
    var alarms =
        (device?.value.alarms ?? const Iterable<Alarm>.empty()).toList();
    return alarms;
  }

  @override
  void addAlarmForActiveDevice(Alarm alarm) {
    var device = getActiveDevice();
    if (device == null) return;
    if (device.value.alarms == null || device.value.alarms?.isEmpty == true) {
      device.value.alarms = HiveList(_alarmBox);
    }
    _alarmBox.add(alarm);
    device.value.alarms!.add(alarm);
    device.value.save();
  }

  @override
  void removeAlarmFromActiveDevice(Alarm alarm) {
    alarm.delete();
  }

  @override
  void updateAlarmForActiveDevice(Alarm alarmToUpdate, Alarm newAlarm) {
    alarmToUpdate.hour = newAlarm.hour;
    alarmToUpdate.minute = newAlarm.minute;
    alarmToUpdate.codeToSend = newAlarm.codeToSend;
    alarmToUpdate.dayOfWeek = newAlarm.dayOfWeek;
    alarmToUpdate.save();
  }
}
