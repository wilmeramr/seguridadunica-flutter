import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unica/services/services.dart';
import 'package:Unica/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/controllers.dart';
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
    final notificacionCtrl = Get.find<NotificacionController>();

    final authService = Provider.of<AuthService>(context, listen: false);
    final items = <ItemBoton>[
      new ItemBoton(
          FontAwesomeIcons.photoVideo,
          'Selfie Propietario',
          Color.fromARGB(255, 90, 31, 226),
          Color.fromARGB(255, 201, 133, 212), () async {
        var conx = await authService.internetConnectivity();
        if (conx)
          Navigator.pushNamed(context, 'inicioSelfie');
        else
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tengo conexion a internet",
              ContentType.failure);
      }),
      new ItemBoton(
          FontAwesomeIcons.idCardAlt,
          'Autorizaciones',
          Color.fromARGB(255, 70, 109, 236),
          Color.fromARGB(255, 117, 221, 145), () async {
        var conx = await authService.internetConnectivity();
        if (conx)
          Navigator.pushNamed(context, 'autorizaInicio');
        else
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tengo conexion a internet",
              ContentType.failure);
      }),
      new ItemBoton(FontAwesomeIcons.recycle, 'Vistas recurrentes',
          Color(0xff317183), Color.fromARGB(255, 152, 70, 153), () async {
        var conx = await authService.internetConnectivity();
        if (conx)
          Navigator.pushNamed(context, 'servicioInicio');
        else
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tengo conexion a internet",
              ContentType.failure);
      }),
      new ItemBoton(
          FontAwesomeIcons.taxi,
          'Delivery,Entregas,otros',
          Color.fromARGB(255, 215, 8, 8),
          Color.fromARGB(255, 129, 95, 232), () async {
        var conx = await authService.internetConnectivity();
        if (conx)
          Navigator.pushNamed(context, 'deliveryInicio');
        else
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tengo conexion a internet",
              ContentType.failure);
      }),
      new ItemBoton(
          FontAwesomeIcons.paw,
          'Mascotas',
          Color.fromARGB(255, 223, 181, 42),
          Color.fromARGB(255, 208, 58, 130), () async {
        var conx = await authService.internetConnectivity();
        if (conx)
          Navigator.pushNamed(context, 'mascotaInicio');
        else
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tengo conexion a internet",
              ContentType.failure);
      }),
      new ItemBoton(
          FontAwesomeIcons.calendar,
          'Eventos',
          Color.fromARGB(255, 45, 56, 207),
          Color.fromARGB(255, 39, 142, 108), () async {
        var conx = await authService.internetConnectivity();
        if (conx)
          Navigator.pushNamed(context, 'eventoInicio');
        else
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tengo conexion a internet",
              ContentType.failure);
      }),
    ];

    List<Widget> itemMap = items.map((item) {
      return FadeInLeft(
        child: Hero(
          tag: Text(item.texto),
          child: BotonGordo(
            iconR: item.icon,
            texto: item.texto,
            color1: item.color1,
            color2: item.color2,
            onPress: item.onPress,
          ),
        ),
      );
    }).toList();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 200),
            child: ListView(physics: const BouncingScrollPhysics(), children: [
              const SizedBox(
                height: 80,
              ),
              FadeInLeft(
                child: Hero(
                  tag: const Text('Notificaciones'),
                  child: BotonGordoNoti(
                    iconR: FontAwesomeIcons.bell,
                    texto: 'Notificaciones',
                    color1: const Color.fromARGB(255, 27, 85, 219),
                    color2: const Color.fromARGB(255, 28, 209, 237),
                    onPress: () async {
                      var conx = await authService.internetConnectivity();
                      if (conx)
                        Navigator.pushNamed(context, 'notificacionInicio');
                      else
                        NotificationsService.showSnackbar(
                            'Oh!',
                            "Debe asegurarse que el dipositivo tengo conexion a internet",
                            ContentType.failure);
                    },
                  ),
                ),
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
              return const CircularProgressIndicator();
            }

            return snapshot.data;
          },
        ),
        Positioned(
            right: 0,
            top: 45,
            child: RawMaterialButton(
              onPressed: () async {
                var result = await authService.logout();
                if (result!.contains('Ok'))
                  Navigator.pushReplacementNamed(context, 'login');
                else
                  NotificationsService.showSnackbar(
                      'Oh!',
                      "Fallo la desconexión del servicio: Intentelo mas tarde. ",
                      ContentType.failure);
              },
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15.0),
              child: const FaIcon(
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
      image: const AssetImage('assets/background.png'),
      color1: const Color.fromARGB(255, 22, 85, 232),
      color2: const Color.fromARGB(255, 67, 107, 195),
    );
  }
}
