import 'package:flutter/material.dart';

class MainScreenButton {
  String iconName;
  Color backgroundColor;
  String title;
  Color iconColor;
  bool isClicked;
  void Function() action;

  MainScreenButton(
      {required this.backgroundColor,
      required this.iconName,
      required this.title,
      required this.action,
      this.isClicked = false,
      this.iconColor = Colors.white});
}
