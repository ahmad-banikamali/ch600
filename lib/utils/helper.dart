import 'package:flutter/material.dart';

void closeKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

bool isPhoneNumberValid(String value) {
  return true;
}

extension ExtendedString on State {
  void pushScreen(Widget route) {
    Navigator.of(context).push(MaterialPageRoute(builder: (c) => route));
  }

  void popScreen(){
    Navigator.pop(context);
  }
}
