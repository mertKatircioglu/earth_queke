import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void showNotificationMessageCurrentCity(String? description, String? title) {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
  var android =  const AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
  );

  const DarwinNotificationDetails darwinNotificationDetails =
  DarwinNotificationDetails(sound: 'city');

  var initSettings =  InitializationSettings(android: android, iOS: initializationSettingsDarwin);
  flutterLocalNotificationsPlugin.initialize(initSettings);


  String groupKey = 'com.example.earth_queke-high_importance_channel';
  var androidPlatformChannelSpecifics =  AndroidNotificationDetails(
    'high_importance_channel',
    'high_importance_channel',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    groupKey: groupKey,
    sound: const RawResourceAndroidNotificationSound('city'),
    //   setAsGroupSummary: true
  );
  Random random =  Random();
  int id = random.nextInt(1000);

  NotificationDetails platformChannelSpecifics =  NotificationDetails(
    android: androidPlatformChannelSpecifics,
    // iOS: darwinNotificationDetails

  );
  flutterLocalNotificationsPlugin.show(
      id, title, description, platformChannelSpecifics);
}

void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
  print("id");
}
