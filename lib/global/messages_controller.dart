
import 'package:earth_queke/global/globals.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';

import '../model/message.dart';

class MessagesController extends GetxController {
  var messages = <Message>[].obs;
  var username = ''.obs;
  var connectedIdList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    username = RxString(authUser.currentUser!.displayName.toString());
  }

  @override
  void onClose() {
    messages.clear();
    super.onClose();
  }

  /// return true if the device id is included in the list of connected devices
  bool isDeviceConnected(String id) =>
      connectedIdList.contains(id) ? true : false;

  /// add the device id to the list of connected devices
  void onConnect(String id) => connectedIdList.add(id);

  /// remove the device id from the list of connected devices
  void onDisconnect(String id) =>
      connectedIdList.removeWhere((element) => element == id);

  void onSendMessage(
      {String? toId,
      String? toUsername,
      String? fromId,
      String? fromUsername,
      String? message}) {
    /// Add the message object received to the messages list
    messages.add(Message(
      sent: true,
      toId: toId!,
      toUsername: toUsername!,
      fromUsername: fromUsername!,
      message: message!,
      dateTime: DateTime.now(),
    ));

    /// This will force a widget rebuild
    update();
  }

  void onReceiveMessage(
      {String? fromId, Payload? payload, ConnectionInfo? fromInfo}) async {
    /// Once receive a payload in the form of Bytes,
    if (payload!.type == PayloadType.BYTES) {
      /// we will convert the bytes into String
      String messageString = String.fromCharCodes(payload.bytes as Iterable<int>);

      /// Add the message object to the messages list
      messages.add(
        Message(
          sent: false,
          fromId: fromId!,
          fromUsername: fromInfo!.endpointName,
          toUsername: username.value,
          message: messageString,
          dateTime: DateTime.now(),
        ),
      );
    }

    /// This will force a widget rebuild
    update();
  }
}
