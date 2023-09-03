import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/ui/bottom_sheets/add_new_device.dart';
import 'package:ch600/ui/bottom_sheets/change_password.dart';
import 'package:ch600/utils/constants.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  var deviceRepository = HiveDeviceRepository();
  late Map<dynamic, Device> allDevices;
  var box = Hive.box(DbConstants.etcDB);
  late bool showLockOnAdvanceScreen = false;
  late bool showLockOnHomeScreen = false;
  late String correctPass;

  @override
  void initState() {
    super.initState();
    showLockOnAdvanceScreen =
        box.get(DbConstants.keyShowLockOnAdvanceScreen, defaultValue: false);
    showLockOnHomeScreen =
        box.get(DbConstants.keyShowLockOnHomeScreen, defaultValue: false);
    correctPass = box.get(DbConstants.keyPassword, defaultValue: "0000");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            setting,
            style: Theme.of(context).textTheme.titleMedium!,
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
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              CheckboxListTile(
                value: showLockOnHomeScreen,
                onChanged: (isEnabled) {
                  showLockOnHomeScreen = isEnabled ?? false;
                  box.put(DbConstants.keyShowLockOnHomeScreen,
                      showLockOnHomeScreen);
                  setState(() {});
                },
                title: Text(
                  "درخواست رمز هنگام ورود به برنامه",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black, fontSize: 15),
                ),
              ),
              // CheckboxListTile(
              //   value: showLockOnAdvanceScreen,
              //   onChanged: (isEnabled) {
              //     showLockOnAdvanceScreen = isEnabled ?? false;
              //     box.put(DbConstants.keyShowLockOnAdvanceScreen,
              //         showLockOnAdvanceScreen);
              //     setState(() {});
              //   },
              //   title: Text(
              //     "درخواست رمز هنگام ورود به قسمت پیشرفته",
              //     style: Theme.of(context)
              //         .textTheme
              //         .titleMedium!
              //         .copyWith(color: Colors.black, fontSize: 15),
              //   ),
              // ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: const ChangePassword(),
                          );
                        });
                  },
                  child: Text(
                    "تغییر رمز برنامه",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),

              Container(
                height: 1,
                width: double.infinity,
                color: Colors.black45,
                margin: const EdgeInsets.all(24),
              ),
              Text(
                devices,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black, fontSize: 15),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (c, i) {
                  return InkWell(
                    onTap: () {
                      var clickedDevice =
                          deviceRepository.getAllDevices().entries.toList()[i];
                      openAddNewDeviceBottomSheet(context,
                          oldDeviceEntry: clickedDevice);
                    },
                    child: ListTile(
                      leading: Text(
                        deviceRepository.getAllDevices()[i]!.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black, fontSize: 15),
                      ),
                      trailing: Text(
                        deviceRepository.getAllDevices()[i]!.phone,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  );
                },
                itemCount: deviceRepository.getAllDevices().length,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade300,borderRadius: const BorderRadius.all(Radius.circular(8))),

                child: TextButton(
                    onPressed: () {
                      openAddNewDeviceBottomSheet(context);
                    },
                    child: Text(
                      addNewDevice,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Theme.of(context).colorScheme.onBackground, fontSize: 15),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void openAddNewDeviceBottomSheet(BuildContext context,
      {MapEntry<dynamic, Device>? oldDeviceEntry}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: AddNewDevice(
              onSaveClick: (newDeviceEntry) {
                deviceRepository.updateDevice(oldDeviceEntry, newDeviceEntry);
                setState(() {});
                popScreen();
              },
              deviceMapEntry: oldDeviceEntry,
            ),
          );
        });
  }
}
