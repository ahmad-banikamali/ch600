class Device {
  String name;
  String phone;
  String password;
  String defaultSimCard;

  Device(
      {required this.name,
      required this.phone,
      this.password = "",
      required this.defaultSimCard});
}
