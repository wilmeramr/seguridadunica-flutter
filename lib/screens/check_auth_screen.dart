import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/screens.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

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
