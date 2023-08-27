import 'dart:async';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/models/device.dart';
import 'package:ch600/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:flutter_sms_dual/flutter_sms_dual.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(AlarmAdapter());
  await Hive.openBox<Device>(DbConstants.deviceDB);
  await Hive.openBox<Alarm>(DbConstants.alarmDB);
  await Hive.openBox(DbConstants.etcDB);
}

/*Future<void> initAlarm() async {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            criticalAlerts:true,
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupName: 'Basic group',
             channelGroupKey: 'basic_channel_group')
      ],
      debug: true);

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: (ReceivedAction receivedAction) async {
      NotificationController.onActionReceivedMethod(receivedAction);
    },
    onNotificationCreatedMethod: (ReceivedNotification receivedNotification) async {
      NotificationController.onNotificationCreatedMethod(receivedNotification);
    },
    onNotificationDisplayedMethod: (ReceivedNotification receivedNotification) async {
      NotificationController.onNotificationDisplayedMethod(
          receivedNotification);
    },
    onDismissActionReceivedMethod: (ReceivedAction receivedAction) async {
      NotificationController.onDismissActionReceivedMethod(receivedAction);
    },
  );

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'basic_channel',
        title: 'wait 5 seconds to show',
        body: 'now is 5 seconds later',
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationInterval(
        interval: 60,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
        repeats: true,
        allowWhileIdle: true,
      ));
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    sendMessage(DateTime.now().toString(), Device(name: "name", phone: "09021014157", defaultSimCard: "2 "),(){});
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {}
}*/

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
    };
    await platform.invokeMethod('setAlarm', arguments);
  } on PlatformException catch (e) {
    print(e);
  }
}
