import 'package:flutter/material.dart';

class MainScreenButton {
  IconData icon;
  Color backgroundColor;
  String title;
  Color iconColor;
  void Function() action;

  MainScreenButton({required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.action,
    this.iconColor = Colors.white});
}
