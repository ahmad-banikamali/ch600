import 'package:ch600/data/models/alarm.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/ui/widgets/device_drop_down.dart';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {

  late DeviceRepository deviceRepository;
  late List<Alarm> alarms;

  @override
  void initState() {
    deviceRepository = HiveDeviceRepository();
    alarms = deviceRepository.getAlarmsForActiveDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const DeviceDropDown(),
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
          itemCount: alarms.length,
          itemBuilder: (c, i) {
            return   Text(
              alarms[i].toString()??"null",
              style: const TextStyle(color: Colors.red),
            );
          }),
    );
  }
}
