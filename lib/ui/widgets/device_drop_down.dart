import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/ui/bottom_sheets/add_new_device.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceDropDown extends ConsumerStatefulWidget {
  const DeviceDropDown({this.onDeviceSelected, super.key});

  final void Function()? onDeviceSelected;

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
    return deviceRepository.getAllDevices().isEmpty
        ? TextButton(
            child: Text("add new device"),
            onPressed: () {
              deviceRepository.addDevice(Device(
                  name: "name",
                  phone: "phone",
                  defaultSimCard: "defaultSimCard"));
              setState(() {});
            },
          )
        : DropdownButton(
            value: deviceRepository.getActiveDevice()?.key,
            items: [
              ...deviceRepository
                  .getAllDevices()
                  .entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(
                          "${e.value.name}///${e.key}",
                          style: const TextStyle(color: Colors.orange),
                        ),
                      )),
              DropdownMenuItem(
                value: null,
                child: TextButton(
                  child: Text("add new device"),
                  onPressed: () {
                    deviceRepository.addDevice(Device(
                        name: "name",
                        phone: "phone",
                        defaultSimCard: "defaultSimCard"));
                    setState(() {});
                  },
                ),
              )
            ],
            onChanged: (key) {
              deviceRepository.activateDeviceWithKey(key);
              setState(() {});
              widget.onDeviceSelected?.call();
            });
  }
}
