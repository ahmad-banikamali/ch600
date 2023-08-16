import 'package:ch600/Utils/constants.dart';
import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/ui/bottom_sheets/add_new_device.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  var deviceRepository = HiveDeviceRepository();
  late Map<dynamic, Device> allDevices;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(setting),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(devices),
            ListView.builder(
              itemBuilder: (c, i) {
                return InkWell(
                    onTap: () {
                      var clickedDevice =
                          deviceRepository.getAllDevices().entries.toList()[i];
                      openAddNewDeviceBottomSheet(context,
                          deviceMapEntry: clickedDevice);
                    },
                    child: Text(
                        "${deviceRepository.getAllDevices()[i]!.name} **"
                        "${deviceRepository.getAllDevices()[i]!.phone} **"
                        "${deviceRepository.getAllDevices()[i]!.password} **"
                        "${deviceRepository.getAllDevices()[i]!.defaultSimCard} "));
              },
              itemCount: deviceRepository.getAllDevices().length,
              shrinkWrap: true,
            ),
            TextButton(
                onPressed: () {
                  openAddNewDeviceBottomSheet(context);
                },
                child: Text(addNewDevice))
          ],
        ),
      ),
    );
  }

  void openAddNewDeviceBottomSheet(BuildContext context,
      {MapEntry<dynamic, Device>? deviceMapEntry}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: AddNewDevice(
              onSaveClick: (device) {
                deviceRepository.updateDevice(device);
                setState(() {});
                popScreen();
              },
              deviceMapEntry: deviceMapEntry,
            ),
          );
        });
  }
}
