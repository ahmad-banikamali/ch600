import 'package:ch600/ui/screens/home_screen.dart';
import 'package:ch600/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LockScreen extends StatefulWidget {

  final void Function() onSuccess;

  const LockScreen({super.key, required this.onSuccess});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  @override
  Widget build(BuildContext context) {
    var correctPassword =
        Hive.box(DbConstants.etcDB).get(DbConstants.keyPassword,defaultValue: "0000");
    var showErrorMessage = false;

    return Scaffold(
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.black),
            onChanged: (v) {
              if (v.length == 4) {
                if (v == correctPassword) {
                  widget.onSuccess();
                } else {
                  setState(() {
                    showErrorMessage = true;
                  });
                }
              } else {
                setState(() {
                  showErrorMessage = false;
                });
              }
            },
          ),
          Text(
            showErrorMessage ? "Error Password" : "",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
