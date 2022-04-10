import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../widgets/headers.dart';

class ItemBoton {
  final IconData icon;
  final String texto;
  final Color color1;
  final Color color2;
  final Function()? onPress;

  ItemBoton(this.icon, this.texto, this.color1, this.color2, this.onPress);
}

class DashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = <ItemBoton>[
      new ItemBoton(
          FontAwesomeIcons.idCardAlt,
          'Autorizaciones',
          Color(0xff6989F5),
          Color(0xff906EF5),
          () => Navigator.pushNamed(context, 'invitarInicio')),
      new ItemBoton(
          FontAwesomeIcons.taxi,
          'Servicios',
          Color(0xff66A9F2),
          Color(0xff536CF6),
          () => Navigator.pushNamed(context, 'servicioInicio')),
      new ItemBoton(
          FontAwesomeIcons.bell,
          'Notificaciones',
          Color(0xff6989F5),
          Color(0xff906EF5),
          () => Navigator.pushNamed(context, 'notificacionInicio')),
      new ItemBoton(FontAwesomeIcons.paw, 'Mascotas', Color(0xffF2D572),
          Color(0xffE06AA3), () {}),
      new ItemBoton(FontAwesomeIcons.calendar, 'Eventos', Color(0xff317183),
          Color(0xff46997D), () {}),
      new ItemBoton(FontAwesomeIcons.newspaper, 'Noticias', Color(0xff66A9F2),
          Color(0xff536CF6), () {}),
      new ItemBoton(FontAwesomeIcons.theaterMasks, 'Theft / Harrasement',
          Color(0xffF2D572), Color(0xffE06AA3), () {}),
      new ItemBoton(FontAwesomeIcons.biking, 'Awards', Color(0xff317183),
          Color(0xff46997D), () {}),
      new ItemBoton(FontAwesomeIcons.carCrash, 'Motor Accident',
          Color(0xff6989F5), Color(0xff906EF5), () {}),
      new ItemBoton(FontAwesomeIcons.plus, 'Medical Emergency',
          Color(0xff66A9F2), Color(0xff536CF6), () {}),
      new ItemBoton(FontAwesomeIcons.theaterMasks, 'Theft / Harrasement',
          Color(0xffF2D572), Color(0xffE06AA3), () {}),
      new ItemBoton(FontAwesomeIcons.biking, 'Awards', Color(0xff317183),
          Color(0xff46997D), () {}),
    ];

    List<Widget> itemMap = items
        .map((item) => FadeInLeft(
              child: Hero(
                tag: item.texto,
                child: BotonGordo(
                  iconR: item.icon,
                  texto: item.texto,
                  color1: item.color1,
                  color2: item.color2,
                  onPress: item.onPress,
                ),
              ),
            ))
        .toList();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 200),
            child: ListView(physics: BouncingScrollPhysics(), children: [
              SizedBox(
                height: 80,
              ),
              ...itemMap
            ]),
          ),
          _Encabezado()
        ],
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Stack(
      children: [
        FutureBuilder(
          future: _dataTitle(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            return snapshot.data;
          },
        ),
        Positioned(
            right: 0,
            top: 45,
            child: RawMaterialButton(
              onPressed: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
              shape: CircleBorder(),
              padding: EdgeInsets.all(15.0),
              child: FaIcon(
                Icons.login_outlined,
                color: Colors.white,
              ),
            ))
      ],
    );
  }

  Future<IconHeader> _dataTitle(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    User sur = await authService.readUser();

    return IconHeader(
      icon: FontAwesomeIcons.shieldAlt,
      country: sur.country,
      name: sur.name,
      lote: sur.lote,
      apellido: sur.apellido,
      email: sur.email,
      rol: sur.rol,
      color1: Color(0xff6989F5),
      color2: Color(0xff906EF5),
    );
  }
}

class BotonGordoTemp extends StatelessWidget {
  const BotonGordoTemp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BotonGordo(
      iconR: FontAwesomeIcons.carCrash,
      texto: 'Motro Acciden',
      color1: Color(0xff6989F5),
      color2: Color(0xff906EF5),
      onPress: () {
        print('Click');
      },
    );
  }
}
