import 'dart:convert';

import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/providers/alarm_provider.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/alarm_repository.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/ui/widgets/device_drop_down.dart';
import 'package:ch600/utils/constants.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late DeviceRepository deviceRepository;
  late AlarmRepository alarmRepository;
  late List<Alarm> alarmsForActiveDevice;
  late List<String> minuteList;
  late List<String> hourList;
  late List<String> dayWeekList;
  late List<String> codeList;
  late Map<String, String> codeMap;
  late var pickerData;
  var data = "";

  @override
  void initState() {
    super.initState();
    deviceRepository = HiveDeviceRepository();
    alarmRepository = HiveAlarmRepository();

    dayWeekList = [
      WeekDay.saturday,
      WeekDay.sunday,
      WeekDay.monday,
      WeekDay.tuesday,
      WeekDay.wednesday,
      WeekDay.thursday,
      WeekDay.friday,
      WeekDay.everyday,
    ];

    codeMap = {
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

    codeList = codeMap.values.toList();

    minuteList = [
      "دقیقه",
      ...List.generate(60, (index) => index.addZeroToString())
    ];
    hourList = [
      "ساعت",
      ...List.generate(24, (index) => index.addZeroToString())
    ];
    pickerData = [dayWeekList, minuteList, hourList, codeMap.keys.toList()];
  }

  @override
  Widget build(BuildContext context) {
    alarmsForActiveDevice = alarmRepository.getAlarmsForActiveDevice();
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            showPicker(null, context, (alarm) {
              alarmRepository.addAlarmForActiveDevice(alarm);
              setState(() {});
            });
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: DeviceDropDown(
          data: data,
          onDeviceSelected: () {
            setState(() {});
          },
          onNewDeviceAdded: () {
            setState(() {});
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/toolbar_logo.png",
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          // Background(),
          Column(
            children: [
              Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "زمان",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "روز",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "کد ارسالی",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "عملیات",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black),
                      )

/*                    TextButton(
                              onPressed: () {
                                var alarmToUpdate = Alarm(
                                    hour: "222hour",
                                    minute: "minute",
                                    dayOfWeek: "222",
                                    codeToSend: "Dddddd");
                                alarmRepository.updateAlarmForActiveDevice(
                                    currentAlarm, alarmToUpdate);
                                setState(() {});
                              },
                              child: Text("update")),
                          TextButton(
                              onPressed: () {
                                alarmRepository
                                    .removeAlarmFromActiveDevice(currentAlarm);
                                setState(() {});
                              },
                              child: Text("delete")),*/
                    ],
                  )),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        alarmRepository.getAlarmsForActiveDevice().length,
                    itemBuilder: (c, i) {
                      var currentAlarm = alarmsForActiveDevice[i];
                      // var currentAlarm = Alarm(
                      //     hour: "22", minute: "51", dayOfWeek: "2", codeToSend: "39");
                      return Container(
                        margin: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${currentAlarm.hour}:${currentAlarm.minute}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.black),
                            ),
                            Text(
                              currentAlarm.dayOfWeek.toDayOfWeek(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.black),
                            ),
                            Text(
                              currentAlarm.codeToSend,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.black),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            InkWell(
                              child: Text(
                                "حذف",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.black),
                              ),
                              onTap: () {
                                alarmRepository.removeAlarmFromActiveDevice(
                                    alarmsForActiveDevice[i]);
                                setState(() {});
                              },
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showPicker(Alarm? currentAlarm, BuildContext context,
      void Function(Alarm) onAlarmSelected) {
    var hourIndex = 0;
    var minuteIndex = 0;
    var dayOfWeekIndex = 0;
    var codeToSendIndex = 0;

    if (currentAlarm != null) {
      hourIndex = hourList.indexOf(currentAlarm.hour);
      minuteIndex = minuteList.indexOf(currentAlarm.minute);
      dayOfWeekIndex =
          dayWeekList.indexOf(currentAlarm.dayOfWeek.toDayOfWeek());
      codeToSendIndex = codeList.indexOf(currentAlarm.codeToSend);
    }

    Picker(
        hideHeader: false,
        confirmText: accept,
        cancelText: cancel,
        selectedTextStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black, fontSize: 15),
        textStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black, fontSize: 15),
        onConfirm: (picker, data) {
          var selectedDay = (data[0] == 7 ? "-1" : data[0]).toString();
          var selectedMinute = minuteList[data[1]];
          var selectedHour = hourList[data[2]];
          var selectedCode = codeMap.values.toList()[data[3]];

          if (data[1] == 0 || data[2] == 0 || data[3] == 0) {
            return;
          }

          var alarm = Alarm(
              hour: "${int.parse(selectedHour)}",
              minute: "${int.parse(selectedMinute)}",
              dayOfWeek: selectedDay,
              codeToSend: codeMap.entries
                  .firstWhere((element) => element.value == selectedCode)
                  .value);

          onAlarmSelected(alarm);
        },
        selecteds: [
          0,
          dayOfWeekIndex,
          minuteIndex,
          hourIndex,
          0,
          codeToSendIndex
        ],
        adapter: PickerDataAdapter<String>(
          pickerData: const JsonDecoder().convert(jsonEncode(pickerData)),
          isArray: true,
        )).showModal(context);
  }
}
