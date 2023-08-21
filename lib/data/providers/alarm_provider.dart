import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/alarm_repository.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

var alarmRepositoryProvider = Provider((ref) => HiveAlarmRepository());

class HiveAlarmRepository extends AlarmRepository {
  late Box<Alarm> _alarmBox;
  late DeviceRepository deviceRepository;

  HiveAlarmRepository() {
    deviceRepository = HiveDeviceRepository();
    _alarmBox = Hive.box<Alarm>(DbConstants.alarmDB);
  }

  @override
  List<Alarm> getAlarmsForActiveDevice() {
    var device = deviceRepository.getActiveDevice();
    var alarms =
        (device?.value.alarms ?? const Iterable<Alarm>.empty()).toList();
    return alarms;
  }

  @override
  void addAlarmForActiveDevice(Alarm alarm) {
    var device = deviceRepository.getActiveDevice();
    if (device == null) return;

    saveAlarmInDatabase(device, alarm);
    // sendSms();
  }

  void saveAlarmInDatabase(MapEntry<dynamic, Device> device, Alarm alarm) {
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


