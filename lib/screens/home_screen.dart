import 'package:ch600/Utils/constants.dart';
import 'package:ch600/models/ui_models/main_screen_button.dart';
import 'package:ch600/providers/device_provider.dart';
import 'package:ch600/repository/device_repository.dart';
import 'package:ch600/widgets/background.dart';
import 'package:ch600/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late List<MainScreenButton> buttonData;
  late DeviceRepository deviceRepository;

  @override
  void initState() {
    super.initState();
    initButtonData();
    deviceRepository = HiveDeviceRepository();
  }

  void initButtonData() { 
    buttonData = [
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: activate,
          action: () {
          },
          icon: Icons.lock_rounded),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: deactivate,
          action: () {
            },
          icon: Icons.lock_open_rounded),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: setting,
          action: () {
          },
          icon: Icons.settings_rounded),
      MainScreenButton(
          backgroundColor: Colors.blue,
          title: advance,
          action: () {
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
          action: () {
          },
          icon: Icons.exit_to_app_rounded),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
