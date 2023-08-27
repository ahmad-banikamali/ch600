import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/ui/screens/advance_screen.dart';
import 'package:ch600/ui/screens/guide_screen.dart';
import 'package:ch600/ui/screens/lock_screen.dart';
import 'package:ch600/ui/screens/settings_screen.dart';
import 'package:ch600/ui/ui_models/main_screen_button.dart';
import 'package:ch600/ui/widgets/background.dart';
import 'package:ch600/ui/widgets/device_drop_down.dart';
import 'package:ch600/ui/widgets/logo.dart';
import 'package:ch600/utils/constants.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late List<MainScreenButton> buttonData;
  final baseIconDir = "assets/images/icons_main_screen/";
  final iconExtension = ".png";
  var data = "";
  late bool showLockScreen;
  late Device? activeDevice;
  DeviceRepository deviceRepository = HiveDeviceRepository();

  @override
  void initState() {
    super.initState();
    showLockScreen = Hive.box(DbConstants.etcDB)
        .get(DbConstants.keyShowLockOnHomeScreen, defaultValue: false);

  }

  void initButtonData() {
    buttonData = [
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: activate,
          action: () {
            if (activeDevice == null) {
              var snackBar = const SnackBar(content: Text('لطفا ابتدا یک دستگاه تعریف کنید'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else {
              sendMessage("11", activeDevice!,(){
                var snackBar = const SnackBar(content: Text('پیام با موفقیت ارسال شد'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            }
          },
          iconName: "lock"),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: deactivate,
          action: () {
            if (activeDevice == null) {
              var snackBar = const SnackBar(content: Text('لطفا ابتدا یک دستگاه تعریف کنید'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else {
              sendMessage("00", activeDevice!, () {
                var snackBar = const SnackBar(
                    content: Text('پیام با موفقیت ارسال شد'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            }
          },
          iconName: "unlock"),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: setting,
          action: () async {
            await pushScreen(const SettingsScreen());
            setState(() {
              // data = data+Random().toString();
            });
          },
          iconName: "setting"),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: advance,
          action: () async {
            await pushScreen(const AdvanceScreen());
            setState(() {});
          },
          iconName: "more"),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: guide,
          action: () {
            pushScreen(const GuideScreen());
          },
          iconName: "information"),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: exitFromApp,
          action: () {
            exit(0);
          },
          iconName: "exit"),
    ];
  }




  @override
  Widget build(BuildContext context) {
    initButtonData();
    activeDevice = deviceRepository
        .getActiveDevice()
        ?.value;



    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: DeviceDropDown(
                data: data,
                onNewDeviceAdded: (){
                  setState(() {

                  });
                },
                onDeviceSelected: (){
                  setState(() {

                  });
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
                const Background(),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Logo(),
                        const SizedBox(
                          height: 16,
                        ),
                        GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: buttonData.map((button) {
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: button.backgroundColor,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: MaterialButton(
                                      padding: const EdgeInsets.all(5),
                                      onPressed: button.action,
                                      child: IconButton(
                                        onPressed: button.action,
                                        icon: ClipOval(
                                            child: Image.asset(
                                              "$baseIconDir${button
                                                  .iconName}$iconExtension",
                                            )),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    button.title,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium,
                                  )
                                ],
                              );
                            }).toList()),
                      ],
                    ),
                  ),
                ),
              ],
            )),
        if (showLockScreen) LockScreen(onSuccess: () {
          showLockScreen = false;
          setState(() {

          });
        },)
      ],
    );
  }
}
