import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:earth_queke/global/globals.dart';
import 'package:earth_queke/model/data_model.dart';
import 'package:earth_queke/services/upper_text_formatter.dart';
import 'package:earth_queke/view_models/queke_view_model.dart';
import 'package:earth_queke/widgets/custom_error_dialog.dart';
import 'package:earth_queke/widgets/custom_loading_dialog.dart';
import 'package:earth_queke/widgets/earthqueke_item.dart';
import 'package:earth_queke/widgets/maps_widget.dart';
import 'package:earth_queke/screens/settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../locator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EarthQuakeViewModel model = EarthQuakeViewModel();
  var getSharedCity = '';
  var getSharedMag = 0.0;
  bool getSharedSwich = false;
  bool isPanicActive = false;
  int dCount=0;
  String? token;
  double? lat;
  double? long;
  int? tel1;
  int? tel2;
  int? tel3;
  DataModel? modelData = DataModel();
  final service = FlutterBackgroundService();
  TextEditingController filterController = TextEditingController();



  Future <void> listenSharedFilter()async{
    isPanicActive = sharedPreferences!.getBool('isActive') ?? false;
    sharedPreferences!.reload();

    if(sharedPreferences!.getBool("swich") == true){
      sharedPreferences!.reload();
      getSharedCity = sharedPreferences!.getString("city").toString();
      getSharedMag = sharedPreferences!.getDouble('mag')!;
      getSharedSwich= sharedPreferences!.getBool("swich")!;
    }
    if(sharedPreferences!.getDouble('lat') !=null){
      sharedPreferences!.reload();
      lat = sharedPreferences!.getDouble('lat');
      long = sharedPreferences!.getDouble('long');
      tel1 = sharedPreferences!.getInt('tel1');
      tel2 = sharedPreferences!.getInt('tel2');
      tel3 = sharedPreferences!.getInt('tel3');
    }
  }



  refreshData(){
    if(getSharedSwich == true){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(microseconds: 10000),(){
          return model.getQuekesFilteredFromUi(getSharedCity, getSharedMag).then((value) {
            setState(() {
              dCount = 0;
              dCount = value.length;
            });
          });
        });
      });

    }else if(getSharedSwich == false){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(microseconds: 10000),(){
          return model.getQuekeFromUi().then((value) {
            setState(() {
              dCount = 0;
              dCount = value.length;
            });
          });
        });
      });
    }
  }


  sendPanicSMS() async{
    Navigator.pop(context);

    if(lat !=null && long !=null){
      showDialog(context: context, builder: (c){
        return CustomLoadingDialog(message: 'YARDIM TALEBİNİZ İLETİLİYOR LÜTFEN SABIRLI OLUP BEKLEYİNİZ.', context: context,);
      });
      String message = "Enkaz altındayım lütfen acil yardım yönlendir! Konum bilgilerim,  Enlem: $lat, Boylam: $long";
      List<String> recipents = ["+90$tel1", "+90$tel2","+90$tel3"];
      String _result = await sendSMS(message: message, recipients: recipents, sendDirect: true)
          .catchError((onError) {
            print(onError);
        showDialog(context: context, builder: (c){
          return CustomErrorDialog(message: 'Bir Hata Meydana Geldi! Tekrar Deneyin ve Sabırlı Olun.');
        });
      }).whenComplete(() {
        Navigator.pop(context);
        showDialog(context: context, builder: (c){
          return CustomErrorDialog(message: 'Konum bilginiz ve durumunuz belirlediğiniz 3 yakınınız ve kolluk kuvvetlerine iletilmiştir. Lütfen sakin kalıp yönergeleri'
              ' gözden geçiriniz.',);
        });

      });

    }else{
      showDialog(context: context, builder: (c){
        return CustomErrorDialog(message: 'Konum Servislerine izin vermediğiniz için bu servis kullanılamıyor.',);
      });
    }

  }

storeNotificationToken() async{
    token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('users').doc(authUser.currentUser!.uid).set({
      "token":token
    },SetOptions(merge: true));
  }


  @override
  void initState() {
    service.on('setAsBackground');
    super.initState();
        listenSharedFilter();
        refreshData();
/*    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
          LocalNotificationService.display(event);
        });
        storeNotificationToken();*/

  }


  sendNotifcation(String token)async{
    final data ={
      'cllick_action':'FLUTTER_CLICK_ACTION',
      'id':1,
      'status':'done',
      'message':'Merhaba enayi :)'
    };
    try{
  http.Response response = await  http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String, String>{
      'Content_Type':'application/json',
      'Authorization':'key=AAAAdjvFL00:APA91bEKsaxYQUMPJmfF6AvO4Yy9CJBOUc9oDjs0bZFtbyWQQyTZfqvxWCJWb3rRS5xRVg4WL6X__UEFfhfzZOkjF64cvJRyuMCi4rkBs5xGSgi5rs0f7axPbncznL4RRGSzQ0tFCaCb',
    },
    body: jsonEncode(<String, dynamic>{
      'notification':<String, dynamic>{'title':'merhaba nenati','body':'asdasdasdasda'},
      'priority':'high',
      'data':data,
      'to':'$token'
    })
    );

  if(response.statusCode ==200){
    print('Mesaj Başarıyla Gönderildi');
  }else{
    print('hata');
  }
    }catch(e){

    }
  }
  Future<List<dynamic>> changeDatSource() {
    if(getSharedSwich == true){
     return model.getQuekesFilteredFromUi(getSharedCity, getSharedMag);
    }else{
      return model.getQuekeFromUi();
    }
  }

  @override
  Widget build(BuildContext context) {
    model =Provider.of<EarthQuakeViewModel>(context);

    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: ()async{
            await Navigator.push(context, MaterialPageRoute(builder: (context)=>
                MapsWdiget(eartQuekeModel: model,)));
          },
              icon: const Icon(Icons.map_sharp, color: kPrymaryColor,)),
          IconButton(onPressed: ()async{
           await Navigator.push(context, MaterialPageRoute(builder: (context)=>
           ChangeNotifierProvider<EarthQuakeViewModel>(
               create: (context)=>locator<EarthQuakeViewModel>(),
               child: const SettingsWidget()))).then((value) {
             setState(() {
                 getSharedSwich = value;
             });
           }).whenComplete(() {
             listenSharedFilter();
              refreshData();
           });
          },
              icon: const Icon(Icons.settings, color: kPrymaryColor,)),
        ],
        elevation: 0,
        backgroundColor: kBackGroundColor,
        title:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
          //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LineChartSample5()));
               // showNotificationMessage("element['title']", 'Deprem:');

                //sendNotifcation(token!);
               // showNotificationMessage('App has gone into the background', 'FlutterApp');

                //onDidReceiveLocalNotification(1, "title", "body", "payload");

              },
              child: Row(
                children: [
                   const Text(
                    "Sismy",
                    style: TextStyle(
                      fontSize: 18,
                      color: kPrymaryColor
                    ),
                  ),

                  const SizedBox(width: 10,),
                  Container(
                    height: 30,
                    width: 30,
                    child: Lottie.asset(
                        "images/splash.json"),
                  ),

                  const SizedBox(width: 10,),
                ],
              ),
            ),
            Visibility(
              visible: getSharedSwich == false ? true : false,
              child: Text("Yurt Genelinde Yaşanan Deprem Sayısı: ${dCount.toString()}"
                ,style: const TextStyle(color: Colors.black87, fontSize: 10),),

            ),
          ],
        ),
      ),
      body: Center(
        child:Column(
          children: [
            Visibility(
              visible: getSharedSwich,
              child:  Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10),
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
                          child: Text("Şehir:  ",
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
                          const SizedBox(width: 8,),
                          const Text(
                            "Şiddet: ",
                            style: TextStyle(
                                fontSize: 14.0,
                                color: kPrymaryColor
                            ),
                          ),
                          Text(
                            "$getSharedMag mag",
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(width: 8,),
                          const Text("D.Sayısı: ", style:TextStyle(
                              fontSize: 14.0,
                              color: kPrymaryColor
                          ),),

                          Text(dCount.toString())

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !getSharedSwich,
              child: Container(
                margin:const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  autofocus: false,
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                  ],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    focusColor: Colors.white,
                    //add prefix icon
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.amber, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "İl, ilçe veya kasaba adı yazınız",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      filterController.text = value.toString();
                    });
                  },
                ),
              ),
            ),
            Flexible(
              child: FutureBuilder<List>(
                future:changeDatSource(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return const Center(child: CupertinoActivityIndicator(),);
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CupertinoActivityIndicator(),);
                  }else if(snapshot.data!.isEmpty){
                    return const Center(child: Text("Bu arama kriterine uygun veri yok."),);
                  }else{
                    //print(filterController.text.toString());
                  var snap =  snapshot.data!.where((i) => i['title'].toString().contains('${filterController.text.toString()}')).toList();
                  //debugPrint(snap.toString(), wrapWidth: 1024);
                    return RefreshIndicator(
                      onRefresh: (){
                       return refreshData();
                      },
                      child: ListView.builder(
                        itemCount: snap.length,
                        itemBuilder: (context, index){
                          var model = DataModel.fromJson(snap[index]);
                          return EarthQuekeItem(earthQuakeViewModel: model);
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:isPanicActive == true ?  FloatingActionButton.large(
        backgroundColor: Colors.red.shade800,
        onPressed: (){
          Future.delayed(const Duration(seconds: 0), () {
            showDialog(
                context: context,
                builder: (c) {
                  return CupertinoAlertDialog(
                    content: const Text(
                        "Başınız dertte mi?",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center),
                    actions: [
                      CupertinoButton(
                        onPressed: ()  {
                          sendPanicSMS();
                        },

                        child: const Text("Evet!"),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text("Hayır"),
                      ),
                    ],
                  );
                });
          });

        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularText(
              radius: 125,
              position: CircularTextPosition.inside,
              children: [
                TextItem(
                    space: 16,
                    startAngle: -90,
                    startAngleAlignment: StartAngleAlignment.center,
                    direction: CircularTextDirection.clockwise,
                    text:const Text('Panik Butonu',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 42),)
                )

              ],
            ),
            const Icon(
              Icons.crisis_alert,
              color: Colors.white,
              size: 45,
            )
          ],
        ),
      ) : null,
    );
  }

/*@override
  void setState(VoidCallback fn) {
        super.setState(fn);
        getSharedSwich == true ? Timer.periodic(const Duration(seconds: 10), (timer) async {
          if (service is AndroidServiceInstance) {
            showNotificationMessage("element['title']", 'FlutterApp');
            *//*    print(value[0]['title']);
            value.forEach((element) {
              showNotificationMessage(element['title'], 'FlutterApp');

            });*//*
          }
        }):null;
  }*/
}

