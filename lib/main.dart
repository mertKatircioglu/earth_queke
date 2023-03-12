import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:earth_queke/services/current_city_local_notification.dart';
import 'package:earth_queke/services/local_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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
String filterId = '11';
String? city="";
double? mag;
bool swich = false;
Position? position;
LocationPermission? permission;
String? newCompleteAddress;
List<Placemark>? placeMarks;
String currentCityId ='11';
var newData;
var currentCity;
var url = Uri.parse("https://api.orhanaydogdu.com.tr/deprem/live.php?limit=900");


Future<void> main() async{
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
  setupLocator();
  await getCurrentLocation();
  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {mapsImplementation.useAndroidViewSurface = true;}
 await initializeBackgroundService();
  //FirebaseMessaging.onBackgroundMessage(_handleBackGroundMessaging);
  runApp( const MyApp());
}

getCurrentLocation() async{
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Konum İzinleri Reddedildi.');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Konum İzinleri Kalıcı Olarak Reddedildi.');
  }

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

  Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium
  );
  position = newPosition;
  placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude
  );
  Placemark pMark = placeMarks![0];
  newCompleteAddress = pMark.administrativeArea.toString().toLowerCase();


  Timer.periodic(const Duration(seconds: 30), (timer) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.reload();
    currentCityId = sharedPreferences!.getString('earthquake_id_city').toString();
    filterId = sharedPreferences!.getString('earthquake_id_filter').toString();
    city = sharedPreferences!.getString('city').toString();
    mag = sharedPreferences!.getDouble('mag');

    final gelenCevap = await httpClient.get(url).catchError((onError){
      print(onError.toString());
    });
    final gelenCevapJson = (jsonDecode(gelenCevap.body));
    if(gelenCevap.statusCode == 200) {
      Iterable son = (((gelenCevapJson["result"]) as List));
      modelList = son.toList();
    }else{
      throw Exception("Veri getirelemedi");
    }


    print("${city}, ${mag}");

    if(sharedPreferences!.getString('city').toString() != 'null'){
       newData =  modelList.where((i) => i['title'].contains('${city!.toUpperCase()}'))
          .where((i) => i['mag'] >= mag ?? 1.0).toList().first;
      if(filterId.characters.toString() != newData['earthquake_id'].toString()){
        sharedPreferences!.setString('earthquake_id_filter', newData['earthquake_id']);
        showNotificationMessage('Şiddeti: ${newData['mag'].toString()}\nSaat: ${DateFormat('hh:mm a').format(DateTime.parse(newData['date'].replaceAll(".", "-"))).toString()}','Merkez Üssü: ${newData['title'].toString().toLowerCase()}');
      }else{
        print('no new data');
      }
    }

    if(modelList.where((i) => i['title'].contains('${newCompleteAddress!.toUpperCase()}')).toList().length >0){
      currentCity =  modelList.where((i) => i['title'].contains('${newCompleteAddress!.toUpperCase()}')).toList().first;
      print(currentCity);
      if(currentCityId.characters.toString() != currentCity['earthquake_id'].toString()){
        sharedPreferences!.setString('earthquake_id_city', currentCity['earthquake_id']);
        showNotificationMessageCurrentCity('Merkez Üssü: ${currentCity['title'].toString().toLowerCase()},\nŞiddeti: ${currentCity['mag']}, Saat: ${DateFormat('hh:mm a').format(DateTime.parse(currentCity['date'].replaceAll(".", "-")))}','DİKKAT! Bulunduğun bölgede deprem var');
      }else{
        print('no city new data');
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


