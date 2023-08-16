import 'package:ch600/Utils/constants.dart';
import 'package:ch600/ui/screens/advance_screen.dart';
import 'package:ch600/ui/screens/settings_screen.dart';
import 'package:ch600/ui/ui_models/main_screen_button.dart';
import 'package:ch600/ui/widgets/background.dart';
import 'package:ch600/ui/widgets/device_drop_down.dart';
import 'package:ch600/ui/widgets/logo.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});


  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late List<MainScreenButton> buttonData;

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
          action: () {},
          icon: Icons.lock_rounded),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: deactivate,
          action: () {},
          icon: Icons.lock_open_rounded),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: setting,
          action: () {
            pushScreen(const SettingsScreen());
          },
          icon: Icons.settings_rounded),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: advance,
          action: () {
            pushScreen( const AdvanceScreen());
          },
          icon: Icons.hardware_rounded),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: guide,
          action: () {},
          icon: Icons.menu_book),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: exit,
          action: () {},
          icon: Icons.exit_to_app_rounded),
    ];
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
                                  padding: const EdgeInsets.all(36),
                                  onPressed: button.action,
                                  child: Icon(
                                    button.icon,
                                    size: 48,
                                    color: Colors.white,
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
