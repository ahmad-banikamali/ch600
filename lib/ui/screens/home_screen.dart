import 'package:ch600/Utils/constants.dart';
import 'package:ch600/ui/screens/advance_screen.dart';
import 'package:ch600/ui/screens/guide_screen.dart';
import 'package:ch600/ui/screens/settings_screen.dart';
import 'package:ch600/ui/ui_models/main_screen_button.dart';
import 'package:ch600/ui/widgets/background.dart';
import 'package:ch600/ui/widgets/device_drop_down.dart';
import 'package:ch600/ui/widgets/logo.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late List<MainScreenButton> buttonData;
  final baseIconDir = "assets/images/icons_main_screen/";
  final iconExtension = ".png";

  @override
  void initState() {
    super.initState();
    initButtonData();
  }

  void initButtonData() {
    buttonData = [
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: activate,
          action: () {

          },
          iconName: "lock"),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: deactivate,
          action: () {},
          iconName: "unlock"),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: setting,
          action: () {
            pushScreen(const SettingsScreen());
          },
          iconName: "setting"),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: advance,
          action: () {
            pushScreen(const AdvanceScreen());
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
          title: exit,
          action: (){},
          iconName: "exit"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
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
                                      "$baseIconDir${button.iconName}$iconExtension",
                                    )),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                button.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                            ],
                          );
                        }).toList()),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
