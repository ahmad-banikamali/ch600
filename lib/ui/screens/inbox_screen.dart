import 'package:ch600/data/models/message.dart';
import 'package:ch600/data/providers/MessageProvider.dart';
import 'package:ch600/data/providers/device_provider.dart';
import 'package:ch600/data/repository/device_repository.dart';
import 'package:ch600/data/repository/messages_repository.dart';
import 'package:ch600/ui/widgets/background.dart';
import 'package:ch600/ui/widgets/bubble.dart';
import 'package:ch600/ui/widgets/device_drop_down.dart';
import 'package:ch600/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late MessagesRepository messageRepository;
  late DeviceRepository deviceRepository;
  var data = "";

  @override
  void initState() {
    messageRepository = DefaultMessageRepository();
    deviceRepository = HiveDeviceRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var activeDevice = deviceRepository.getActiveDevice();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: DeviceDropDown(
          data: data,
          onNewDeviceAdded: () {
            setState(() {});
          },
          onDeviceSelected: () {
            setState(() {});
          },
        ),
      ),
      body: Stack(
        children: [
          const Background(),
          FutureBuilder<List<Message>>(
            future: messageRepository.getAllMessagesForSelectedDevice(),
            initialData: const Iterable<Message>.empty().toList(),
            builder: (context, snapshot) {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                      snapshot.data == null
                          ? "در حال دریافت اطلاعات"
                          : activeDevice == null
                              ? "ابتدا یک دستگاه تعریف کنید"
                              : "پیامی با این دستگاه مبادله نشده است",
                      style: Theme.of(context).textTheme.titleMedium!),
                );
              }
              List<Message> messages = snapshot.data!;
              return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (c, i) {
                    var message = messages[i];
                    return BubbleNormal(
                        messageOwner: "${
                          message.kind == MessageKind.receive
                              ? activeDevice?.value.name ?? ""
                              : "من                   "
                        } ${DateFormat('E').format(message.time).toPersianWeekday()} ${DateFormat('HH:mm').format(message.time)}",
                        text: message.content,
                        isReceiver: message.kind == MessageKind.receive,
                        color: Colors.white,
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black87));
                  });
            },
          ),
        ],
      ),
    );
  }
}
