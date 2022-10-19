import 'package:animate_do/animate_do.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unica/services/services.dart';
import 'package:Unica/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

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

class DashScreen extends StatefulWidget {
  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  String _authStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    //initPlugin();
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
      await Future.delayed(const Duration(milliseconds: 200));
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
    final notificacionCtrl = Get.find<NotificacionController>();
    final emeCtrl = Get.find<EmeController>();

    final authService = Provider.of<AuthService>(context, listen: false);
    final items = <ItemBoton>[
      ItemBoton(
          FontAwesomeIcons.newspaper,
          'Noticias',
          Color.fromARGB(255, 31, 226, 44),
          Color.fromARGB(255, 169, 228, 68), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          Navigator.pushNamed(context, 'inicioNoticia');
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
      ItemBoton(
          FontAwesomeIcons.photoVideo,
          'Selfie Propietario',
          const Color.fromARGB(255, 90, 31, 226),
          const Color.fromARGB(255, 201, 133, 212), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          Navigator.pushNamed(context, 'inicioSelfie');
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
      ItemBoton(
          FontAwesomeIcons.idCardAlt,
          'Autorizaciones',
          const Color.fromARGB(255, 70, 109, 236),
          const Color.fromARGB(255, 117, 221, 145), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          Navigator.pushNamed(context, 'autorizaInicio');
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
      ItemBoton(
          FontAwesomeIcons.recycle,
          'Vistas recurrentes',
          const Color(0xff317183),
          const Color.fromARGB(255, 152, 70, 153), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          Navigator.pushNamed(context, 'servicioInicio');
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
      ItemBoton(
          FontAwesomeIcons.taxi,
          'Entregas Inmediatas, otros',
          const Color.fromARGB(255, 215, 8, 8),
          const Color.fromARGB(255, 129, 95, 232), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          Navigator.pushNamed(context, 'deliveryInicio');
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
      ItemBoton(
          FontAwesomeIcons.paw,
          'Mascotas',
          const Color.fromARGB(255, 223, 181, 42),
          const Color.fromARGB(255, 208, 58, 130), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          Navigator.pushNamed(context, 'mascotaInicio');
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
      ItemBoton(
          FontAwesomeIcons.calendar,
          'Eventos',
          const Color.fromARGB(255, 45, 56, 207),
          const Color.fromARGB(255, 39, 142, 108), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          Navigator.pushNamed(context, 'eventoInicio');
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
      ItemBoton(
          FontAwesomeIcons.ruler,
          'Reglemantos',
          Color.fromARGB(255, 207, 172, 45),
          const Color.fromARGB(255, 39, 142, 108), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          Navigator.pushNamed(context, 'inicioReglamento');
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
      ItemBoton(
          FontAwesomeIcons.paypal,
          'Expensas',
          Color.fromARGB(255, 45, 207, 164),
          const Color.fromARGB(255, 39, 142, 108), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          Navigator.pushNamed(context, 'inicioExpensa');
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
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
                  tag: const Text('EMERGENCIAS'),
                  child: BotonGordoEme(
                    iconR: FontAwesomeIcons.broadcastTower,
                    texto: 'EMERGENCIAS',
                    color1: const Color.fromARGB(255, 219, 27, 27),
                    color2: const Color.fromARGB(255, 237, 28, 129),
                    onPress: () async {
                      Navigator.pushNamed(context, 'inicioEmergencias');
                    },
                  ),
                ),
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
                      if (conx) {
                        Navigator.pushNamed(context, 'notificacionInicio');
                      } else {
                        NotificationsService.showSnackbar(
                            'Oh!',
                            "Debe asegurarse que el dipositivo tenga conexión  a internet",
                            ContentType.failure);
                      }
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
        // UpgradeAlert(),
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
                if (result!.contains('Ok')) {
                  Navigator.pushReplacementNamed(context, 'login');
                } else {
                  NotificationsService.showSnackbar(
                      'Oh!',
                      "Fallo la desconexión del servicio: Intentelo mas tarde. ",
                      ContentType.failure);
                }
              },
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15.0),
              child: const FaIcon(
                Icons.login_outlined,
                color: Colors.white,
              ),
            )),
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
