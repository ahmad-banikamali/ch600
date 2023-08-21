import 'package:ch600/data/models/alarm.dart';
import 'package:hive/hive.dart';

part 'device.g.dart';

@HiveType(typeId: 1)
class Device extends HiveObject {
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

  @HiveField(5)
  HiveList<Alarm>? alarms;

  Device(
      {required this.name,
      required this.phone,
      this.password = "",
      required this.defaultSimCard,
      this.isActive = false,
      this.alarms});

  @override
  String toString() {
    return 'Device{name: $name, phone: $phone, password: $password, defaultSimCard: $defaultSimCard, isActive: $isActive, alarms: $alarms}';
  }


}
