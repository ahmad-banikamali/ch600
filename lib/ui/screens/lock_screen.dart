import 'package:ch600/ui/widgets/background.dart';
import 'package:ch600/utils/constants.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LockScreen extends StatefulWidget {
  final void Function() onSuccess;

  const LockScreen({super.key, required this.onSuccess});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  var showErrorMesssage = false;

  @override
  Widget build(BuildContext context) {
    var correctPassword = Hive.box(DbConstants.etcDB)
        .get(DbConstants.keyPassword, defaultValue: "0000");

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "رمز ورود را وارد کنید",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 15),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white,
                    activeFillColor: Colors.transparent,
                    inactiveFillColor: Colors.transparent,
                    selectedFillColor: Colors.transparent,
                  ),
                  cursorColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 15),
                  onCompleted: (v) {
                    if (v.replaceFarsiNumber() == correctPassword.toString().replaceFarsiNumber()) {
                      widget.onSuccess();
                    }
                  },
                  onChanged: (v) {
                    showErrorMesssage = v.length == 4 && v.replaceFarsiNumber() != correctPassword.toString().replaceFarsiNumber();
                    setState(() {});
                  },
                ),
              ),
              if (showErrorMesssage)
                Text(
                  "رمز ورود اشتباه است",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 15),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
