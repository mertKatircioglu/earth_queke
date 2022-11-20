import 'dart:convert';

import 'package:earth_queke/global/globals.dart';
import 'package:earth_queke/main.dart';
import 'package:earth_queke/model/data_model.dart';
import 'package:earth_queke/view_models/queke_view_model.dart';
import 'package:earth_queke/widgets/earthqueke_item.dart';
import 'package:earth_queke/widgets/maps_widget.dart';
import 'package:earth_queke/widgets/settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/preferences_service.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);


  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final _preferencesService = PreferencesService();
  EarthQuakeViewModel? model;
  var getSharedCity = '';
  var getSharedMag = 0.0;
  bool getSharedSwich = false;


  Future <void> listenSharedFilter()async{
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.reload();
    getSharedCity = sharedPreferences!.getString("city")!;
    getSharedMag = sharedPreferences!.getDouble("mag")!;
    getSharedSwich= sharedPreferences!.getBool("swich")!;
  }



  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (message.notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(notification.hashCode, notification!.title, notification.body,NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: "ic_launcher",
            priority: Priority.max,
            importance: Importance.max,
            enableVibration: true,
            channelDescription: channel.description,
            color: Colors.deepPurple,
            playSound: true,
          )
          ),
            payload: json.encode(message.data),
          );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification != null && android !=null){
        showDialog(context: context, builder: (_){
          return AlertDialog(
            title: Text(notification.title.toString()),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(notification.body.toString())
                ],
              ),
            ),
          );
        });
      }
    });
        super.initState();
        listenSharedFilter();
        getSharedSwich ?  WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(microseconds: 200),(){
            return model!.getQuekesFilteredFromUi(getSharedCity, getSharedMag);
          });
        }) : null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(microseconds: 200),(){
            return model!.getQuekeFromUi();
          });
        });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final settings = await _preferencesService.getSettings();
    setState(() {
      getSharedCity = settings.city;
      getSharedSwich = settings.swich;
      getSharedMag = settings.mag;
    });
  }


  @override
  Widget build(BuildContext context) {
    model =Provider.of<EarthQuakeViewModel>(context);
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: ()async{
            await Navigator.push(context, MaterialPageRoute(builder: (context)=>
                MapsWdiget(eartQuekeModel: model,)));
          },
              icon: const Icon(Icons.map_sharp, color: kPrymaryColor,)),
          IconButton(onPressed: ()async{
           await Navigator.push(context, MaterialPageRoute(builder: (context)=>
           const SettingsWidget())).then((value) {
             setState(() {
               if(value !=null){
                 getSharedSwich = value;
               }else{
                 getSharedSwich = false;
               }
             });
           });
          },
              icon: const Icon(Icons.settings, color: kPrymaryColor,)),
        ],
        elevation: 0,
        backgroundColor: kBackGroundColor,
        title:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                 const Text(
                  "Sismo Servis",
                  style: TextStyle(
                    fontSize: 18,
                    color: kPrymaryColor
                  ),
                ),
                const SizedBox(width: 10,),
                Container(
                  height: 40,
                  width: 40,
                  child: Lottie.asset(
                      "images/splash.json"),
                )
              ],
            ),
           const Text("Türkiye'de yaşanan anlık deprem olaylarını takip edebilirsiniz.",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 9
              ),
            ),

          ],
        ),
      ),
      body: Center(
        child:Column(
          children: [
            Visibility(
              visible: getSharedSwich,
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 18),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        child:const Center(
                          child: Text("Seçilen Filtre:  ",
                            style: TextStyle(fontSize: 14,
                            color: kPrymaryColor
                            ),),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            getSharedCity ?? "",
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                         const SizedBox(width: 20,),
                         const Text(
                            "Şiddeti: ",
                            style: TextStyle(
                              fontSize: 14.0,
                                color: kPrymaryColor
                            ),
                          ),
                          Text(
                            "${getSharedMag} mag",
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: FutureBuilder<List>(
                future:getSharedSwich ? model!.getQuekesFilteredFromUi(getSharedCity, getSharedMag) : model!.getQuekeFromUi(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return const Center(child: CupertinoActivityIndicator(),);
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CupertinoActivityIndicator(),);
                  }else if(snapshot.data!.length == 0){
                    return const Center(child: Text("Bu arama kriterine uygun veri yok."),);
                  } return RefreshIndicator(
                    onRefresh: model!.refresh,
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){
                          var model =  DataModel.fromJson(snapshot.data![index]);
                          return EarthQuekeItem(earthQuakeViewModel: model);
                        },

                    ),
                  );
                },
              ),
            ),
          ],
        ),

      ),
    );
  }

  @override
  void setState(VoidCallback fn) async{
    listenSharedFilter();

    super.setState(fn);
  }



}

