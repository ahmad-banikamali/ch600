import 'package:hive/hive.dart';

part 'alarm.g.dart';


@HiveType(typeId: 2)
class Alarm extends HiveObject {

  @HiveField(1)
  String hour;

  @HiveField(2)
  String minute;

  @HiveField(3)
  String dayOfWeek;

  @HiveField(4)
  String codeToSend;

  Alarm(
      {required this.hour,
      required this.minute,
      required this.dayOfWeek,
      required this.codeToSend});

  @override
  String toString() {
    return 'Alarm{hour: $hour, minute: $minute, dayOfWeek: $dayOfWeek, codeToSend: $codeToSend}';
  }
}
