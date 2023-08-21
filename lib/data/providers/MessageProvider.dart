import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/models/message.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/data/repository/messages_repository.dart';
import 'package:sms_advanced/sms_advanced.dart';

class DefaultMessageRepository extends MessagesRepository {
  late SmsQuery query;
  late Device? selectedDevice;

  DefaultMessageRepository() {
    query = SmsQuery();
    final DeviceRepository deviceRepository = HiveDeviceRepository();
    selectedDevice = deviceRepository.getActiveDevice()?.value;
  }

  @override
  Future<List<Message>> getAllMessagesForSelectedDevice() async {
    if (selectedDevice == null) {
      return [];
    } else {
      List<SmsMessage> messages = await query.querySms(
          kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent],
          address: selectedDevice!.phone);
      return messages
          .map((e) => Message(
              kind: e.kind ?? SmsMessageKind.Draft,
              content: e.body ?? "",
              time: e.date!))
          .toList();
    }
  }

  @override
  getReceivedMessagesForSelectedDevice() {
    return [];
  }

  @override
  getSentMessagesForSelectedDevice() {
    return [];
  }
}
