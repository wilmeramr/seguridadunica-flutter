import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:Unica/screens/screens.dart';
import 'package:Unica/services/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/controllers.dart';

class CheckAuthScreen extends StatefulWidget {
  @override
  State<CheckAuthScreen> createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
  String _authStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 1000));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Querido usuario'),
          content: const Text(
              'Nos preocupamos por su privacidad y seguridad de los datos.'
              'Podemos seguir usando tus datos para mejorar nuestra app para ti? \n\nPuedes cambiar tu elección en cualquier momento en la configuración de la aplicación. '
              'Nuestros socios recopilarán datos y utilizarán un identificador único en su dispositivo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final notificacionCtrl = Get.put(NotificacionController());
    final emeCtrl = Get.put(EmeController());

    final badgeCtrl = Get.put(BadgeController());

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return Text('Espere');

            if (snapshot.data == '') {
              Future.microtask(() => {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => LoginScreen(),
                            transitionDuration: Duration(seconds: 0)))
                  });
            } else {
              Future.microtask(() async => {
                    await authService.readUser(),
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => DashScreen(),
                            transitionDuration: Duration(seconds: 0)))
                  });
            }

            return Container();
          },
        ),
      ),
    );
  }
}
