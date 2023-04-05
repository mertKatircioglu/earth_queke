import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global/dates_controller.dart';
import '../global/devices_controller.dart';
import '../global/globals.dart';
import '../widgets/device_card.dart';

class BtChatDevices extends StatelessWidget {
  // final greetingsController = Get.put(DatesController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackGroundColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
            icon:const Icon(Icons.arrow_back, color: kPrymaryColor,)),
        title:const Text(
          "Blouthoot Chat İletişim",
          style: TextStyle(
            color: kPrymaryColor,
          ),
        ),
      ),
      body: MessengerBody(),
    );
  }
}

class MessengerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<DevicesController>(
      init: DevicesController(context),
      builder: (controller) {
        return controller.devices.isNotEmpty
            ? ListView.builder(
          itemCount: controller.devices.length,
          itemBuilder: (BuildContext context, int index) {
            return DeviceCard(
              device: controller.devices[index],
              username: controller.username.value,
            );
          },
        )
            :  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CupertinoActivityIndicator(),
              Text('Yakınlardaki cihazlar taranıyor. Lütfen bekleyin...')
            ],
          ),
        );
      },
    );
  }
}
