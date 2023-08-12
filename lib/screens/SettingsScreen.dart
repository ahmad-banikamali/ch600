import 'package:ch600/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ch600/Utils/constants.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  var numbers = <Device>[];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(setting),
        ),
        body: Form(
            child: Column(
          children: [
            Text(devices),
            ListView.builder(itemBuilder: (_, index) {
              return ListTile(
                trailing: Text(
                  numbers[index].name,
                ),
                leading: Text(numbers[index].phone),
              );
            })
          ],
        )),
      ),
    );
  }
}
