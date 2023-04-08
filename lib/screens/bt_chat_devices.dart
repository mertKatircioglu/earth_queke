import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:sismy/global/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

import '../widgets/chat.dart';



enum DeviceType { advertiser, browser }
class BtChatDevices extends StatefulWidget {
  const BtChatDevices({required this.deviceType});

  final DeviceType? deviceType;

  @override
  State<BtChatDevices> createState() => _BtChatDevicesState();
}

class _BtChatDevicesState extends State<BtChatDevices> {
  List<Device> devices = [];
  List<Device> connectedDevices = [];
  late NearbyService nearbyService;
  late StreamSubscription subscription;
  bool loading= false;
  late Chat activity;
  bool isInit = false;
  String loadingMessage= "";

  @override
  void initState() {
    super.initState();
    if(widget.deviceType ==DeviceType.advertiser ){
      loadingMessage ="Yardım çağrıları taranıyor. Lütfen bekleyiniz...";
    } else if(widget.deviceType == DeviceType.browser){
      loadingMessage ="Çevrenizde yardım arayan kişiler aranıyor. Lütfen bekleyiniz...";
    }
    init();
  }

  @override
  void dispose() {
    subscription.cancel();
    nearbyService.stopBrowsingForPeers();
    nearbyService.stopAdvertisingPeer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: kBackGroundColor,
        appBar: AppBar(
      elevation: 0,
      backgroundColor: kBackGroundColor,
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      },
          icon:const Icon(Icons.arrow_back, color: kPrymaryColor,)),
      title: Text(
        widget.deviceType!.name,
        style: const TextStyle(
          color: kPrymaryColor,
        ),
      ),
    ),
        body:loading == false? ListView.builder(
            itemCount: getItemCount(),
            itemBuilder: (context, index) {
              final device = widget.deviceType == DeviceType.advertiser
                  ? connectedDevices[index]
                  : devices[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                margin: const EdgeInsets.all(8.0),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Expanded(
                              child: GestureDetector(
                                //onTap: () => _onTabItemListener(device),
                                child: Column(
                                  textDirection: TextDirection.rtl,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 9.0),
                                    Text("${device.deviceName}",),
                                    Text(
                                      getStateName(device.state),
                                      style: TextStyle(
                                          color: getStateColor(device.state)),
                                    ),
                                  ],

                                ),
                              )),
                          // Request connect
                       InkWell(
                            onTap: () => _onButtonClicked(device),
                            child: Container(
                                margin: const EdgeInsets.all(3.0),
                                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: getColor(device.state))
                                ),
                                child: Text(getButtonStateName(device.state), style:TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: getColor(device.state)
                                ))),
                          ),

                          Visibility(
                            visible: SessionState.connected == device.state,
                            child: InkWell(
                              onTap: (){
                                if(device.state == SessionState.connected) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Bağlantı Kuruldu"),
                                    backgroundColor: Colors.green,
                                  ));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chat(userName: authUser.currentUser!.displayName!,
                                            connected_device: device,nearbyService: nearbyService)),
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Bağlantı Henüz Yapılmadı"),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(3.0),
                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.amber)
                                  ),
                                  child: const Text("Görüşmeye Başla", style:TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.amber
                                  ))),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }): Center(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
              const CupertinoActivityIndicator(),
              Text(loadingMessage, textAlign: TextAlign.center,)
          ],
        ),
            ));
  }

  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "Bağlı Değil";
      case SessionState.connecting:
        return "Bağlanıyor";
      default:
        return "Bağlandı";
    }
  }

  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "Bağlan";
      case SessionState.connecting:
        return "Bağlanıyor";
      default:
        return "Bağlantıyı Kes";
    }
  }

  Color getColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.green;
      case SessionState.connecting:
        return Colors.blue;
      default:
        return Colors.red;
    }
  }
  IconData getButtonStateIcon(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return  Icons.link;
      case SessionState.connecting:
        return  Icons.autorenew;
      default:
        return  Icons.link_off ;
    }
  }

  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.red;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.green;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  int getItemCount() {
    if (widget.deviceType == DeviceType.advertiser) {
      return connectedDevices.length;
    } else {
      return devices.length;
    }
  }

  _onButtonClicked(Device device) {

    switch (device.state) {
      case SessionState.notConnected:

        nearbyService.invitePeer(
          deviceID: device.deviceId,
          deviceName: device.deviceName,
        );
        break;
      case SessionState.connected:
        nearbyService.disconnectPeer(deviceID: device.deviceId);
        break;
      case SessionState.connecting:
        break;
    }
  }

  void init() async {
    setState(() {
      loading = true;
    });
    nearbyService = NearbyService();
    String devInfo = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      devInfo = androidInfo.model;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      devInfo = iosInfo.localizedModel;
    }
    await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: authUser.currentUser!.displayName.toString(),
        strategy: Strategy.Wi_Fi_P2P,
        callback: (isRunning) async {
          if (isRunning) {
            if (widget.deviceType == DeviceType.browser) {

              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(Duration(microseconds: 200));
              await nearbyService.startBrowsingForPeers();
            } else {
              await nearbyService.stopAdvertisingPeer();
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(Duration(microseconds: 200));
              await nearbyService.startAdvertisingPeer();
              await nearbyService.startBrowsingForPeers();
            }
          }
        });
    subscription =
        nearbyService.stateChangedSubscription(callback: (devicesList) {
          devicesList.forEach((element) {
            print(" deviceId: ${element.deviceId} | deviceName: ${element.deviceName} | state: ${element.state}");
            if (Platform.isAndroid) {
              if (element.state == SessionState.connected) {
                nearbyService.stopBrowsingForPeers();
              } else {
                nearbyService.startBrowsingForPeers();
              }
            }
          });

          setState(() {
            devices.clear();
            devices.addAll(devicesList);
            loading = false;
            connectedDevices.clear();
            connectedDevices.addAll(devicesList
                .where((d) => d.state == SessionState.connected)
                .toList());
          });
        });


  }
}


