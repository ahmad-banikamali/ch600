import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceDropDown extends ConsumerStatefulWidget {
  const DeviceDropDown({super.key});

  @override
  ConsumerState<DeviceDropDown> createState() => _DeviceDropDownState();
}

class _DeviceDropDownState extends ConsumerState<DeviceDropDown> {
  late MapEntry<dynamic, Device>? activeDevice;
  late Map<dynamic, Device> allDevices;
  late DeviceRepository deviceRepository;

  @override
  void initState() {
    deviceRepository = HiveDeviceRepository();
    activeDevice = deviceRepository.getActiveDevice();
    allDevices = deviceRepository.getAllDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: deviceRepository.getActiveDevice()!.key,
        items: allDevices.entries
            .map((e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(
                    e.value.name,
                    style: const TextStyle(color: Colors.red),
                  ),
                ))
            .toList(),
        onChanged: (key) {
          deviceRepository.activateDeviceWithKey(key);
          setState(() {});
        });
  }
}
