//05:7C:D6:13:10:72:79:87:98:9A:32:F7:3F:BF:6B:9C:8F:58:5A:28

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../controllers/controllers.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static String? token;
  static StreamController<String> _messageStream =
      new StreamController.broadcast();

  static Stream<String> get messageStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    //print('backgound handler ${message.messageId}');

    _messageStream.add(message.data['producto'] ?? 'no data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print('_onMessageOpenApp handler ${message.messageId}');

    _messageStream.add(message.data['producto'] ?? 'no data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //print('_onMessageOpenApp handler ${message.messageId}');
    _messageStream.add(message.data['producto'] ?? 'no data');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();

    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();

    print('token $token');

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print('User push notifications status ${settings.authorizationStatus}');
  }

  static closeStreams() {
    _messageStream.close();
  }
}
