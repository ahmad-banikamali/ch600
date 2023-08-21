import 'package:ch600/data/models/message.dart';

abstract class MessagesRepository {
  List<Message> getSentMessagesForSelectedDevice();

  List<Message> getReceivedMessagesForSelectedDevice();

  Future<List<Message>> getAllMessagesForSelectedDevice();
}
