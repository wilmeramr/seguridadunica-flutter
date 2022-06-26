import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/controllers.dart';

class NotificationsService {
  static late GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static late GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  static showMyDialogAndroid(
      BuildContext context, String titulo, String body) async {
    Platform.isAndroid
        ? showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                elevation: 5,
                title: Text(titulo),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(body),
                    SizedBox(
                      height: 15,
                    ),
                    FaIcon(FontAwesomeIcons.windowClose)
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          )
        : showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(titulo),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(body),
                    SizedBox(
                      height: 15,
                    ),
                    FlutterLogo(
                      size: 100,
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
  }

  static showMyDialogIOS(
      BuildContext context, String titulo, String body) async {
    return showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(titulo),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(body),
                SizedBox(
                  height: 15,
                ),
                FlutterLogo(
                  size: 100,
                )
              ],
            ),
          );
        });
  }

  static showSnackbar(String title, String message, ContentType contentType) {
    final snackBar = new SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ));

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
