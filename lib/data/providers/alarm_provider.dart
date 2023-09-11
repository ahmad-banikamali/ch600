import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/alarm_repository.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/utils/constants.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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
    saveAlarmInDatabase(alarm);
    scheduleMessage(alarm);
  }

  void saveAlarmInDatabase(Alarm alarm) {
    var device = deviceRepository.getActiveDevice();
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
    removeAlarm(alarm);
    alarm.delete();
  }

  @override
  void updateAlarmForActiveDevice(Alarm alarmToUpdate, Alarm newAlarm) {
    alarmToUpdate.hour = newAlarm.hour;
    alarmToUpdate.minute = newAlarm.minute;
    alarmToUpdate.codeToSend = newAlarm.codeToSend;
    alarmToUpdate.dayOfWeek = newAlarm.dayOfWeek;
    alarmToUpdate.save();
    scheduleMessage(alarmToUpdate);
  }

  void scheduleMessage(Alarm alarm) async {
    var device = deviceRepository.getActiveDevice();
    if (device == null) {
      return;
    }
    if (await Permission.sms.request().isGranted) setAlarm(device.value, alarm);
  }
}
