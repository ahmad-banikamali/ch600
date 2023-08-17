class AdvanceScreenButton {
  String iconName;
  String title;
  String? codeToSend;
  void Function()? action;

  AdvanceScreenButton(
      {required this.iconName, required this.title,this.action,this.codeToSend});
}
