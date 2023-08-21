import 'dart:convert';

import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/providers/alarm_provider.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/alarm_repository.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/ui/widgets/background.dart';
import 'package:ch600/ui/widgets/device_drop_down.dart';
import 'package:ch600/utils/constants.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

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
  late List<int> codeList;
  late var pickerData;

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
    ];
    codeList = [36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50];
    minuteList = List.generate(60, (index) => index.addZeroToString());
    hourList = List.generate(24, (index) => index.addZeroToString());
    pickerData = [
      ["زمان"],
      dayWeekList,
      minuteList,
      hourList,
      ["کد"],
      codeList
    ];
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
          onDeviceSelected: () {
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
          ListView.builder(
              itemCount: alarmRepository.getAlarmsForActiveDevice().length,
              itemBuilder: (c, i) {
                var currentAlarm = alarmsForActiveDevice[i];
                // var currentAlarm = Alarm(
                //     hour: "22", minute: "51", dayOfWeek: "2", codeToSend: "39");
                return Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          "ویرایش",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.black),
                        ),
                        onLongPress: (){
                          alarmRepository.removeAlarmFromActiveDevice(currentAlarm);
                        },
                        onTap: () {
                          showPicker(
                            currentAlarm,
                            context,
                            (alarm) {
                              alarmRepository.updateAlarmForActiveDevice(
                                  currentAlarm, alarm);
                              setState(() {
                              });
                            },
                          );
                        },
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
                  ),
                );
              }),
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
      codeToSendIndex = codeList.indexOf(int.parse(currentAlarm.codeToSend));
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
          var selectedDay =  data[1].toString() ;
          var selectedMinute = minuteList[data[2]];
          var selectedHour = hourList[data[3]];
          var selectedCode = codeList[data[5]];
          onAlarmSelected(Alarm(
              hour: selectedHour,
              minute: selectedMinute,
              dayOfWeek: selectedDay,
              codeToSend: selectedCode.toString()));
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
