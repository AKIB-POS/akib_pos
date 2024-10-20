import 'dart:convert';

import 'package:akib_pos/features/dashboard/presentation/pages/notification_handler_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class FirebaseMessagingApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_important_channel',
    'High Importance Notifications',
    description: "This channel is used for important notification ",
    importance: Importance.defaultImportance,
  );

  final _localNotification = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message){

    if(message == null) return;
    print("MASOK");

    final data  = message.data;

    print(navigatorKey.currentContext);
    try {
      navigatorKey.currentState?.pushNamed(
        NotificationHandlerPage.route,
        arguments: message,
      );
      print('Navigation successful');
    } catch (e, stackTrace) {
      print('Error during navigation: $e');
      print(stackTrace);
    }
    if(message.data.containsKey('type')){
      // final data  = message.data;
      // showData(data);
      switch(data['type']){
        case "news":
          break;
        case "update":
          break;
        case "promotion":
          break;
        case "message":
          break;
        case "default":
          break;
      }
    }
    else{

    }
    // navigatorKey.currentState?.pushNamed(
    //     NotificationScreen.route, arguments: message
    // );
  }

  Future initPushNotifications() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true
    );

    final token = await _firebaseMessaging.getToken();
    print(token);
    
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if(notification == null) return;

      _localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id,
                  _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: '@drawable/launcher_icon'
              )
          ),
          payload: jsonEncode(message.toMap())
      );
    });
  }

  Future<void> initLocalNotifications() async{
    const android = AndroidInitializationSettings('@drawable/launcher_icon');
    const IOS = DarwinInitializationSettings();
    const settings = InitializationSettings(
        android: android,
        iOS: IOS
    );

    await _localNotification.initialize(settings,
        onDidReceiveNotificationResponse: (data) {
          final message = RemoteMessage.fromMap(jsonDecode(data.payload!));
          handleMessage(message);
        });

    final platform = _localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    if(!kIsWeb) {
      await _firebaseMessaging.subscribeToTopic("news");
      await _firebaseMessaging.subscribeToTopic("update");
      await _firebaseMessaging.subscribeToTopic("promotion");

      initLocalNotifications();
    }
    final token = await _firebaseMessaging.getToken();
    print(token);

    initPushNotifications();
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}