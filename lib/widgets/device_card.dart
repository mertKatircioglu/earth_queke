import 'dart:math' as math;

import 'package:earth_queke/widgets/show_alert_dialog_box.dart';
import 'package:flutter/material.dart';

import '../../../model/device.dart';
import '../../../model/message.dart';
import '../global/devices_controller.dart';
import '../screens/chat.dart';


class DeviceCard extends StatefulWidget {
  final Device? device;
  final String? username;
  final List<Message>? messages;

  const DeviceCard({
    this.device,
    this.username,
    this.messages,
  });

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool? isConnected;
  DevicesController? bleMessengerController;

  @override
  void initState() {
    super.initState();
    isConnected = widget.device!.isConnected;
    bleMessengerController = DevicesController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: Offset(10, 10),
              color: Colors.black12,
            ),
          ],
        ),
        child: Card(
          color: isConnected! ? Colors.blue[50] : null,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: InkWell(
            onTap: () {
              isConnected!
                  ? Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>Chat(
                  deviceId: widget.device!.id,
                  deviceUsername: widget.device!.name,
                  appUser: widget.username!,
                )),
              )
                  : showAlertDialogBox(
                context: context,
                header: 'Note:',
                message: 'You are not yet connected to the user.',
                actionButtons: [
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(
                    isConnected! ? Icons.chat_rounded : Icons.person_pin_rounded,
                    size: 36,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(
                  widget.device!.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: ElevatedButton(
                  child: Text(
                    btnLabel(
                        condition: isConnected!,
                        leftText: 'Disconnect',
                        rightText: 'Connect'),
                    style: TextStyle(
                      color: isConnected! ? Colors.white : Colors.black54,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.resolveWith(getColor),
                  ),
                  onPressed: () {
                    if (!isConnected!) {
                      bleMessengerController!.requestDevice(
                        requestContext: context,
                        nickname: widget.username,
                        deviceId: widget.device!.id,
                        onConnectionResult: (endpointId, status) {
                          if (status.toString() == 'Status.CONNECTED') {
                            setState(() {
                              isConnected = true;
                            });
                          } else {
                            setState(() {
                              isConnected = false;
                            });
                          }
                        },
                        onDisconnected: (id) {
                          setState(() {
                            isConnected = false;
                          });
                        },
                      );
                    } else {
                      bleMessengerController!.disconnectDevice(
                        id: widget.device!.id,
                        updateStateFunction: () {
                          setState(() {
                            isConnected = false;
                          });
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return isConnected! ? Colors.redAccent : Colors.greenAccent;
    }
    return isConnected! ? Colors.red : Theme.of(context).buttonColor;
  }

  String btnLabel({bool? condition, String? leftText, String? rightText}) {
    return condition! ? leftText! : rightText!;
  }
}
