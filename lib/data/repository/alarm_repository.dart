import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/models/device.dart';

abstract class AlarmRepository{
  List<Alarm> getAlarmsForActiveDevice();

  void addAlarmForActiveDevice(Alarm alarm);

  void removeAlarmFromActiveDevice(Alarm alarm);

  void updateAlarmForActiveDevice(Alarm alarmToUpdate,Alarm newAlarm);

  void refreshAlarmsForDevise(Device device);

}