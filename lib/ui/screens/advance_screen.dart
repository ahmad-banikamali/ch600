import 'package:ch600/ui/screens/home_screen.dart';
import 'package:ch600/ui/widgets/device_drop_down.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';

class AdvanceScreen extends StatefulWidget {
  const AdvanceScreen({super.key});

  @override
  State<AdvanceScreen> createState() => _AdvanceScreenState();
}

class _AdvanceScreenState extends State<AdvanceScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        pushScreen(const HomeScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const DeviceDropDown(),
        ),
        body: GridView.builder(
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (c, i) {
              return const Text("data",
                style: const TextStyle(color: Colors.red),);
            }),
      ),
    );
  }
}
