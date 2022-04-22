import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EnviarNotificacionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Background(color1: Color(0xff6989F5), color2: Colors.white),
          Container(
            //  margin: EdgeInsets.only(top: 200),
            child: Hero(
              tag: Text('Notificaciones'),
              child: BotonGordoNoti(
                iconL: FontAwesomeIcons.bell,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Crear Notificación',
                color1: Color.fromARGB(255, 105, 245, 203),
                color2: Color.fromARGB(255, 129, 95, 232),
                onPress: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
