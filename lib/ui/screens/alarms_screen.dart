import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/ui/widgets/device_drop_down.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late DeviceRepository deviceRepository;
  late List<Alarm> alarmsForActiveDevice;

  @override
  void initState() {
    super.initState();
    deviceRepository = HiveDeviceRepository();
  }

  @override
  Widget build(BuildContext context) {
    alarmsForActiveDevice = deviceRepository.getAlarmsForActiveDevice();
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            deviceRepository.addAlarmForActiveDevice(Alarm(
                hour: "hour",
                minute: "minute",
                dayOfWeek: "dayOfWeek",
                codeToSend: "codeToSend"));
            setState(() {});
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: DeviceDropDown(
          onDeviceSelected: refresh,
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
      body: ListView.builder(
          itemCount: deviceRepository.getAlarmsForActiveDevice().length,
          itemBuilder: (c, i) {
            var currentAlarm = alarmsForActiveDevice[i];
            return Row(
              children: [
                Text(
                  currentAlarm.hour ?? "null",
                  style: const TextStyle(color: Colors.red),
                ),
                TextButton(
                    onPressed: () {
                      var alarmToUpdate = Alarm(
                          hour: "222hour",
                          minute: "minute",
                          dayOfWeek: "222",
                          codeToSend: "Dddddd");
                      deviceRepository.updateAlarmForActiveDevice(
                          currentAlarm, alarmToUpdate);
                      setState(() {});
                    },
                    child: Text("update")),
                TextButton(
                    onPressed: () {
                      deviceRepository
                          .removeAlarmFromActiveDevice(currentAlarm);
                      setState(() {});
                    },
                    child: Text("delete")),
              ],
            );
          }),
    );
  }
}
