import 'package:earth_queke/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';

import 'package:nearby_connections/nearby_connections.dart';

import '../global/devices_controller.dart';

/// Called upon Connection request (on both devices)
/// Both need to accept connection to start sending/receiving
void showBottomModal(
    BuildContext context, String cId, String id, ConnectionInfo info) {
  final bleMessengerController = DevicesController(context);
  showModalBottomSheet(
    context: context,
    builder: (builder) {
      return Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Text('${info.endpointName}. Sizinle bağlantı kurmak istiyor.', style: const TextStyle(fontSize: 18),),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomPrimaryButton(
                  radius: 10,
                  text: "Reddet",
                  function: () {
                    try {
                      bleMessengerController.rejectConnection(id: id);
                    } catch (e) {
                      print(e);
                    }
                    Navigator.pop(context);
                  },
                ),
                CustomPrimaryButton(
                  radius:10,
                  text: "Kabul Et",
                  function: () {
                    cId = id;
                    try {
                      bleMessengerController.acceptConnection(
                          id: id, info: info);
                    } catch (e) {
                      print(e);
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
