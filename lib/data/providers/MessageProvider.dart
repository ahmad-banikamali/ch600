import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/models/message.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/data/repository/messages_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';

class DefaultMessageRepository extends MessagesRepository {
  late SmsQuery query;
  late Device? selectedDevice;
  late DeviceRepository deviceRepository;

  DefaultMessageRepository() {
    query = SmsQuery();
    deviceRepository = HiveDeviceRepository();
  }

  @override
  Future<List<Message>> getAllMessagesForSelectedDevice() async {
    selectedDevice = deviceRepository.getActiveDevice()?.value;
    if (!await Permission.sms.request().isGranted) {
      return [];
    }

    if (selectedDevice == null) {
      return [];
    }

    List<SmsMessage> messages = await query.querySms(
        kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent],
        address: selectedDevice!.phone);

    var list = messages
        .map((e) => Message(
            kind: e.kind ?? SmsMessageKind.Draft,
            content: e.body ?? "",
            time: e.date!))
        .toList();

    return list;
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
