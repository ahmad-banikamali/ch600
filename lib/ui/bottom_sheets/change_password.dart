import 'package:ch600/utils/constants.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late String correctPass;
  var key = GlobalKey<FormState>();
  var currentPassController = TextEditingController();
  var newPassController = TextEditingController();
  var renewPassController = TextEditingController();
  var box = Hive.box(DbConstants.etcDB);

  @override
  void initState() {
    correctPass = box.get(DbConstants.keyPassword, defaultValue: "");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                ],
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black),
                controller: newPassController,
                validator: (s) {
                  if (s != null && s.isNotEmpty && s.length != 4 || !s!.replaceFarsiNumbers().isNumeric()) {
                    return " رمز باید از 4 کارکتر عددی تشکیل شده باشد";
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'رمز جدید')),
            TextFormField(
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (s) {
                  if(s==null || s.isEmpty){
                    return "رمز جدید را مجددا وارد نمایید";
                  }
                  if (s.replaceFarsiNumbers() != newPassController.value.text.replaceFarsiNumbers()) {
                    return "رمزها همخوانی ندارند";
                  }
                  return null;
                },
                controller: renewPassController,
                decoration: const InputDecoration(labelText: 'تکرار رمز جدید')),
            TextButton(
                onPressed: () {
                  if (key.currentState?.validate() == true) {
                    box.put(
                        DbConstants.keyPassword, newPassController.value.text.replaceFarsiNumbers());
                    popScreen();
                  }
                },
                child: Text(
                  "تایید",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
