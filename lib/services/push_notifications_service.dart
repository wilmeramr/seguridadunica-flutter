//SHA1- 5A:A7:81:F1:BF:7A:8B:D5:7D:5E:38:FC:02:C4:16:DE:0A:4E:BA:59

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

    token = await FirebaseMessaging.instance.getToken();

    print('token $token');

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static closeStreams() {
    _messageStream.close();
  }
}
