import 'package:ch600/data/models/device.dart';
import 'package:ch600/data/models/message.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/data/repository/messages_repository.dart';
import 'package:ch600/utils/helper.dart';
import 'package:permission_handler/permission_handler.dart';

class DefaultMessageRepository extends MessagesRepository {
  late Device? selectedDevice;
  late DeviceRepository deviceRepository;


  DefaultMessageRepository() {
    deviceRepository = HiveDeviceRepository();
  }

  @override
  Future<List<Message>> getAllMessagesForSelectedDevice() async {
    selectedDevice = deviceRepository
        .getActiveDevice()
        ?.value;
    if (selectedDevice == null) {
      return [];
    }

    if (!await Permission.sms
        .request()
        .isGranted) {
      return [];
    }

    return await getSms(selectedDevice!.phone);
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
