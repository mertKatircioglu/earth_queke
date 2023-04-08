
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:vibration/vibration.dart';

import '../global/globals.dart';

class Chat extends StatefulWidget{
  String userName;
  Device connected_device;
  NearbyService nearbyService;
  var chat_state;
  List<ChatMessage> receiveMessages= [];

  Chat({ required this.connected_device, required this.nearbyService, required this.userName,required this.receiveMessages});


  @override
  State<StatefulWidget> createState()  => _Chat();

}
class _Chat extends State<Chat>{
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;
  List<ChatMessage> messages = [];
  final myController = TextEditingController();

  void addMessgeToList(ChatMessage  obj){
    Vibration.vibrate(duration: 100);
    setState(() {
      messages.insert(0, obj);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    receivedDataSubscription.cancel();
  }
  void init(){
    if(widget.receiveMessages.isNotEmpty){
      messages.addAll(widget.receiveMessages);
    }
    receivedDataSubscription =
        this.widget.nearbyService.dataReceivedSubscription(callback: (data) {
          var obj = ChatMessage(messageContent: data["message"], messageType: "receiver");
          addMessgeToList(obj);
        });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back,color: Colors.black,),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(

                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 5,),
                      Text(widget.connected_device.deviceName,style: const TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                      const SizedBox(height: 3,),
                      const Text("Bağlandı",style: TextStyle(color: Colors.green, fontSize: 13),),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      backgroundColor: kBackGroundColor,
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            reverse: true,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10,bottom: 70),
            itemBuilder: (context, index){
              return Container(
                padding: const EdgeInsets.only(left: 10,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (messages[index].messageType == "receiver"?Alignment.topLeft:Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].messageType  == "receiver"?Colors.grey.shade200:Colors.amber[300]),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(messages[index].messageContent, style: const TextStyle(fontSize: 15),),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  const SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){
                      if(widget.connected_device.state == SessionState.notConnected) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Bağlantı Kesildi"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                      widget.nearbyService.sendMessage(widget.connected_device.deviceId, myController.text);
                      var obj = ChatMessage(messageContent: myController.text, messageType: "sender");
                      addMessgeToList(obj);
                      myController.text = "";
                    },
                    backgroundColor: Colors.amber[700],
                    elevation: 0,
                    child: const Icon(Icons.send,color: Colors.white,size: 18,textDirection: TextDirection.ltr,),
                  ),
                  const SizedBox(width: 15,),

                  Expanded(
                    child: TextField(
                      textDirection: TextDirection.ltr,
                      decoration: const InputDecoration(
                        hintTextDirection: TextDirection.ltr,
                        hintText: "Mesajınızı yazın",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,

                      ),
                      controller: myController,
                    ),
                  ),

                ],

              ),
            ),
          ),
        ],
      ),
    );
  }


}

class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({ required this.messageContent,  required this.messageType});
}