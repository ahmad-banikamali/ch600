import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/ui/bottom_sheets/add_new_device.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceDropDown extends ConsumerStatefulWidget {
  const DeviceDropDown({this.data, this.onDeviceSelected, super.key,this.onNewDeviceAdded});

  final void Function()? onDeviceSelected;
  final String? data;
  final void Function()? onNewDeviceAdded;

  @override
  ConsumerState<DeviceDropDown> createState() => _DeviceDropDownState();
}

class _DeviceDropDownState extends ConsumerState<DeviceDropDown> {
  late MapEntry<dynamic, Device>? activeDevice;
  late Map<dynamic, Device> allDevices;
  late DeviceRepository deviceRepository;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceRepository = HiveDeviceRepository();
    allDevices = deviceRepository.getAllDevices();
    var key2 = deviceRepository.getActiveDevice()?.key;
    if (deviceRepository.getAllDevices().isEmpty) {
      return Text(
        "دستگاهی موجود نیست${widget.data}",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontSize: 15),
      );
    } else {
      return DropdownButton(
            value: key2,
          dropdownColor: Theme.of(context).primaryColor,
            items: [
              ...deviceRepository
                  .getAllDevices()
                  .entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(
                          "${e.value.name}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Theme.of(context).colorScheme.onPrimary, fontSize: 15),
                        ),
                      )),

            ],
            onChanged: (key) {
              deviceRepository.activateDeviceWithKey(key);
              setState(() {});
              widget.onDeviceSelected?.call();
            });
    }
  }


  // void openAddNewDeviceBottomSheet(BuildContext context,) {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return Padding(
  //           padding: MediaQuery.of(context).viewInsets,
  //           child: AddNewDevice(
  //             onSaveClick: (newDeviceEntry) {
  //               deviceRepository.addDevice(newDeviceEntry.value);
  //               deviceRepository.activateLatestDevice();
  //               setState(() {});
  //               popScreen();
  //               widget.onNewDeviceAdded?.call();
  //             }
  //           ),
  //         );
  //       });
  // }
}
