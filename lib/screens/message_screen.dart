import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments ?? 'no data';
    return Scaffold(
        appBar: AppBar(
          title: Text('Message'),
        ),
        body: Center(
          child: Text(
            '${args}',
            style: TextStyle(fontSize: 30),
          ),
        ));
  }
}
