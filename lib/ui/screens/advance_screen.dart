import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/ui/screens/home_screen.dart';
import 'package:ch600/ui/screens/inbox_screen.dart';
import 'package:ch600/ui/screens/alarms_screen.dart';
import 'package:ch600/ui/screens/lock_screen.dart';
import 'package:ch600/ui/ui_models/advance_screen_button.dart';
import 'package:ch600/ui/widgets/background.dart';
import 'package:ch600/ui/widgets/device_drop_down.dart';
import 'package:ch600/utils/constants.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AdvanceScreen extends StatefulWidget {
  const AdvanceScreen({super.key});

  @override
  State<AdvanceScreen> createState() => _AdvanceScreenState();
}

class _AdvanceScreenState extends State<AdvanceScreen> {
  late List<AdvanceScreenButton> buttonData;
  final baseIconDir = "assets/images/icons_advance_screen/";
  final iconExtension = ".png";
  var data = "";
  final DeviceRepository deviceRepository = HiveDeviceRepository();

  late bool showLockScreen;

  @override
  void initState() {
    initButtonData();
    showLockScreen = Hive.box(DbConstants.etcDB)
        .get(DbConstants.keyShowLockOnAdvanceScreen, defaultValue: false);
    super.initState();
  }

  void initButtonData() {
    buttonData = [
      AdvanceScreenButton(
          title: activateWithSound,
          codeToSend: "12",
          iconName: "lockpage_lock"),
      AdvanceScreenButton(
          title: deactivateWithSound,
          codeToSend: "10",
          iconName: "lockpage_unlock"),
      AdvanceScreenButton(
          title: report, codeToSend: "99", iconName: "scenario"),
      AdvanceScreenButton(
          title: semiActive, codeToSend: "15", iconName: "lockpage_lock"),
      AdvanceScreenButton(
          title: activateRemote, codeToSend: "40", iconName: "remote_active"),
      AdvanceScreenButton(
          title: deactivateRemote,
          codeToSend: "41",
          iconName: "remote_deactive"),
      AdvanceScreenButton(
          title: activateKeypad, codeToSend: "45", iconName: "keypad_active"),
      AdvanceScreenButton(
          title: deactivateKeypad,
          codeToSend: "46",
          iconName: "keypad_deactive"),
      AdvanceScreenButton(
          title: activateConnection, codeToSend: "50", iconName: "user_active"),
      AdvanceScreenButton(
          title: deactivateConnection,
          codeToSend: "51",
          iconName: "user_deactive"),
      AdvanceScreenButton(
          title: timers,
          action: () async {
            await pushScreen(const AlarmScreen());
            data = data;
            setState(() {});
          },
          iconName: "timer"),
      AdvanceScreenButton(title: emergency, codeToSend: "70", iconName: "bell"),
      AdvanceScreenButton(
          title: messagesInbox,
          action: () async {
            await pushScreen(const InboxScreen());
            setState(() {});
          },
          iconName: "inbox"),
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
                        handleSendMessage(button.codeToSend!);
                      }

                      return Center(
                        child: IconButton(
                            onPressed: button.codeToSend == null
                                ? button.action
                                : sendMessage,
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
          if (showLockScreen)
            LockScreen(onSuccess: () {
              showLockScreen = false;
              setState(() {});
            })
        ],
      ),
    );
  }

  void handleSendMessage(String codeToSend) {
    var device = deviceRepository.getActiveDevice()?.value;
    if (device == null) {
      showNoDeviceFoundDialog();
      return;
    }

    sendMessage(codeToSend, device, () {
      var snackBar = const SnackBar(content: Text('پیام با موفقیت ارسال شد'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  void showNoDeviceFoundDialog() {
    var snackBar = const SnackBar(content: Text('لطفا ابتدا یک دستگاه تعریف کنید'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
