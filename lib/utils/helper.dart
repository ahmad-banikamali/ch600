import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/models/device.dart';
import 'package:ch600/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(AlarmAdapter());
  await Hive.openBox<Device>(deviceDB);
  await Hive.openBox<Alarm>(alarmDB);
}

void closeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

bool isPhoneNumberValid(String value) {
  return true;
}

extension ExtendedString on State {
  void pushScreen(Widget route) {
    Navigator.of(context).push(MaterialPageRoute(builder: (c) => route));
  }

  void popScreen() {
    Navigator.pop(context);
  }

  void replaceScreen(Widget route) {
    popScreen();
    pushScreen(route);
  }
}

void sendMessage(String code) {}
