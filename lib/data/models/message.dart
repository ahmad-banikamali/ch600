
class Message {

  MessageKind kind;
  String content;
  DateTime time;

  Message({required this.kind, required this.content, required this.time});

  @override
  String toString() {
    return 'Message{type: $kind, content: $content, time: $time}';
  }

}

enum MessageKind{
  send,receive
}

