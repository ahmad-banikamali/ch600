import 'package:sms_advanced/sms_advanced.dart';

class Message {

  SmsMessageKind kind;
  String content;
  DateTime time;

  Message({required this.kind, required this.content, required this.time});

  @override
  String toString() {
    return 'Message{type: $kind, content: $content, time: $time}';
  }

}


