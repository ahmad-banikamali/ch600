import 'package:hive/hive.dart';

part 'device.g.dart';

@HiveType(typeId: 1)
class Device {
  @HiveField(0)
  String name;

  @HiveField(1)
  String phone;

  @HiveField(2)
  String password;

  @HiveField(3)
  String defaultSimCard;

  @HiveField(4)
  bool isActive;

  Device(
      {required this.name,
      required this.phone,
      this.password = "",
      required this.defaultSimCard,
      this.isActive = false
      });
}
