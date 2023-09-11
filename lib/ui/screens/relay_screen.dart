import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/ui/ui_models/relay_screen_button.dart';
import 'package:ch600/ui/widgets/background.dart';
import 'package:ch600/ui/widgets/device_drop_down.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';

class RelayScreen extends StatefulWidget {
  const RelayScreen({super.key});

  @override
  State<RelayScreen> createState() => _RelayScreenState();
}

class _RelayScreenState extends State<RelayScreen> {
  late List<RelayScreenButton> buttonData;
  final baseIconDir = "assets/images/icons_relay_screen/";
  final iconExtension = ".png";
  var data = "";
  final DeviceRepository deviceRepository = HiveDeviceRepository();

  @override
  void initState() {
    initButtonData();

    super.initState();
  }

  void initButtonData() {
    buttonData = [
      RelayScreenButton(
          title: "رله 1 روشن", codeToSend: "20", iconName: "lamp"),
      RelayScreenButton(
          title: "رله 1 خاموش", codeToSend: "21", iconName: "lamp_off"),
      RelayScreenButton(
          title: "رله 2 روشن", codeToSend: "25", iconName: "lamp"),
      RelayScreenButton(
          title: "رله 2 خاموش", codeToSend: "26", iconName: "lamp_off"),
      RelayScreenButton(
          title: "رله 3 روشن", codeToSend: "30", iconName: "lamp"),
      RelayScreenButton(
          title: "رله 3 خاموش", codeToSend: "31", iconName: "lamp_off"),
      RelayScreenButton(
          title: "رله 4 روشن", codeToSend: "35", iconName: "lamp"),
      RelayScreenButton(
          title: "رله 4 خاموش", codeToSend: "36", iconName: "lamp_off"),
      RelayScreenButton(
          title: "همه رله ها روشن", codeToSend: "37", iconName: "lamp"),
      RelayScreenButton(
          title: "همه رله ها خاموش", codeToSend: "38", iconName: "lamp_off"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        popScreen();
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/images/toolbar_logo.png",
                  ),
                )
              ],
              title: DeviceDropDown(
                data: data,
                onNewDeviceAdded: () {
                  setState(() {});
                },
                onDeviceSelected: () {
                  setState(() {});
                },
              ),
            ),
            body: Stack(
              children: [
                const Background(),
                GridView.builder(
                    itemCount: buttonData.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (c, i) {
                      var button = buttonData[i];

                      void sendMessage() {
                        handleSendMessage(
                            button.codeToSend!,
                            deviceRepository.getActiveDevice()?.value,
                            clickData, (isClicked) {
                          clickData = isClicked;
                          setState(() {});
                        });
                      }

                      return Center(
                        child: IconButton(
                            onPressed: sendMessage,
                            icon: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2)),
                                  child: Image.asset(
                                      "$baseIconDir${button.iconName}$iconExtension"),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  button.title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            )),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
