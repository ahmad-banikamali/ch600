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

  void handleSendMessage(String codeToSend, Device? device, isClicked,
      void Function(bool) onClick) {
    if (device == null) {
      showSnackBar('لطفا ابتدا یک دستگاه تعریف کنید');
      return;
    }
    if (isClicked) {
      showSnackBar("از دستور قبلی حد اقل باید 10 ثانیه گذشته باشد");
      Future.delayed(const Duration(milliseconds: 10000), () {
        onClick(false);
      });
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("آیا از ارسال دستور مطمئن هستید ؟",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black)),
            actions: [
              TextButton(
                onPressed: () {
                  popScreen();
                },
                // function used to perform after pressing the button
                child: Text('بی خیال',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  sendMessage(codeToSend, device, () {
                    showSnackBar('پیام با موفقیت ارسال شد');
                  });
                  popScreen();
                  onClick(true);
                },
                child: Text('تایید',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.green)),
              ),
            ],
          );
        });
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    var snackBar = SnackBar(
        content: Text(text, style: Theme.of(context).textTheme.titleMedium!));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

var codeMap = {
  "نوع دستور": "-1",
  deactivate: "00",
  deactivateWithSound: "10",
  activate: "11",
  activateWithSound: "12",
  semiActive: "15",
  activateRemote: "40",
  deactivateRemote: "41",
  activateKeypad: "45",
  deactivateKeypad: "46",
  activateConnection: "50",
  deactivateConnection: "51",
  emergency: "70",
  report: "99",
};

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
      'alarmId': alarm.key,
      'codeName': codeMap.entries
          .firstWhere((element) => element.value == alarm.codeToSend)
          .key,
      'deviceName': device.name
    };
    await platform.invokeMethod('setAlarm', arguments);
  } on PlatformException catch (e) {}
}

Future<void> removeAlarm(int alarmId) async {
  try {
    var arguments = {
      'alarmId': alarmId,
    };
    await platform.invokeMethod('removeAlarm', arguments);
  } on PlatformException catch (e) {}
}
