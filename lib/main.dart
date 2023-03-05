import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:earth_queke/model/data_model.dart';
import 'package:earth_queke/services/local_notification.dart';
import 'package:earth_queke/view_models/queke_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:earth_queke/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'global/globals.dart';
import 'locator.dart';
import 'package:http/http.dart' as http;

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

/*@pragma('vm:entry-point')
Future<void> _handleBackGroundMessaging(RemoteMessage message) async {
//on click listner
}*/

final http.Client httpClient = http.Client();
List modelList = [];
String title = "1111";
String? city="";
double? mag;
bool swich = false;

Future<void> main() async{
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {mapsImplementation.useAndroidViewSurface = true;}
  sharedPreferences = await SharedPreferences.getInstance();

 await initializeBackgroundService();
  //FirebaseMessaging.onBackgroundMessage(_handleBackGroundMessaging);
  runApp( const MyApp());
}
initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      initialNotificationContent: 'Arkaplan deprem takip analizi açık.',
      initialNotificationTitle: 'Sismo Servis',
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });


  Timer.periodic(const Duration(seconds: 30), (timer) async {
    if (service is AndroidServiceInstance) {
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences!.reload();
      if(sharedPreferences!.getString('city').toString().characters.length > 2){
        title = sharedPreferences!.getString('notifCity').toString();
        city = sharedPreferences!.getString('city').toString();
        mag = sharedPreferences!.getDouble('mag');
        var url = Uri.parse("https://api.orhanaydogdu.com.tr/deprem/live.php?limit=900");
        final gelenCevap = await httpClient.get(url).catchError((onError){
          print(onError.toString());
        });
        final gelenCevapJson = (jsonDecode(gelenCevap.body));
        if(gelenCevap.statusCode == 200){
          Iterable son = (((gelenCevapJson["result"]) as List));
          modelList =son.toList();
          var newData =  modelList.where((i) => i['title'].contains('${city!.toUpperCase()}'))
              .where((i) => i['mag'] >= mag ?? 1.0).toList().first;
          if(title.characters.toString() != newData['title'].toString()){
            sharedPreferences!.setString('notifCity', newData['title']);
            showNotificationMessage('Şiddeti: ${newData['mag']}\nSaat: ${DateFormat('hh:mm a').format(DateTime.parse(newData['date'].replaceAll(".", "-")))}','Merkez Üssü: ${newData['title'].toString().toLowerCase()}');
          }else{
            print('no new data');
          }

        }else{
          throw Exception("Veri getirelemedi");
        }
      }
    }
  });

}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Türkiye Deprem Bilgileri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen()
    );
  }
}


