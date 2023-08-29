import 'dart:async';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/models/device.dart';
import 'package:ch600/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_dual/flutter_sms_dual.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(AlarmAdapter());
  await Hive.openBox<Device>(DbConstants.deviceDB);
  await Hive.openBox<Alarm>(DbConstants.alarmDB);
  await Hive.openBox(DbConstants.etcDB);
}


void closeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

bool isPhoneNumberValid(String value) {
  return true;
}

extension ExtendedState on State {
  Future pushScreen(Widget route) {
    return Navigator.of(context).push(MaterialPageRoute(builder: (c) => route));
  }

  void popScreen() {
    Navigator.pop(context);
  }

  void replaceScreen(Widget route) {
    popScreen();
    pushScreen(route);
  }
}

extension ExtendedInt on int {
  String addZeroToString() {
    if (this < 10) {
      return "0$this";
    }
    return "$this";
  }
}

extension ExtendedString on String {
  String toDayOfWeek() {
    var dayOfWeek = "";
    switch (this) {
      case "0":
        dayOfWeek = WeekDay.saturday;
      case "1":
        dayOfWeek = WeekDay.sunday;
      case "2":
        dayOfWeek = WeekDay.monday;
      case "3":
        dayOfWeek = WeekDay.tuesday;
      case "4":
        dayOfWeek = WeekDay.wednesday;
      case "5":
        dayOfWeek = WeekDay.thursday;
      case "6":
        dayOfWeek = WeekDay.friday;
      case "-1":
        dayOfWeek = WeekDay.everyday;
      default:
        dayOfWeek = WeekDay.error;
    }
    return dayOfWeek;
  }
}

void sendMessage(String code, Device device, callback) async {
  if (await Permission.sms.request().isGranted) {
    await FlutterSmsDual().sendSMS(
      message: "$code#${device.password}",
      recipients: [device.phone],
      sendDirect: true,
      sim: device.defaultSimCard,
    );
    callback();
  } else {}
}

const platform = MethodChannel('ch600.com/channel');

Future<void> setAlarm(Device device, Alarm alarm) async {
  try {
    var arguments = {
      'phone': device.phone,
      'password': device.password,
      'defaultSimCard': device.defaultSimCard,
      'dayOfWeek': alarm.dayOfWeek,
      'hour': alarm.hour,
      'minute': alarm.minute,
      'codeToSend': alarm.codeToSend,
      'alarmId':alarm.key
    };
    await platform.invokeMethod('setAlarm', arguments);
  } on PlatformException catch (e) {
  }
}

Future<void> removeAlarm(int alarmId) async {
  try {
    var arguments = {
      'alarmId': alarmId,
    };
    await platform.invokeMethod('removeAlarm', arguments);
  } on PlatformException catch (e) {
  }
}
