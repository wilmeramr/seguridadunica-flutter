import 'dart:ffi';

import 'package:Unica/controllers/controllers.dart';
import 'package:Unica/controllers/selfie_controller.dart';
import 'package:Unica/widgets/widgets.dart';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/services.dart';

final Uri _url = Uri.parse('https://flutter.dev');

class ItemBotonEme {
  final IconData icon;
  final String texto;
  final Color color1;
  final Color color2;
  final Function()? onPress;

  ItemBotonEme(this.icon, this.texto, this.color1, this.color2, this.onPress);
}

class InicioEmeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaffoldBodyEme(),
    );
  }
}

class ScaffoldBodyEme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Background(color1: Color(0xff6989F5), color2: Colors.white),
          _MainScroll()
        ],
      ),
    );
  }
}

class _MainScroll extends StatelessWidget {
  const _MainScroll({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController eviarAController = new TextEditingController();
    final emeCtrl = Get.put(EmeController());
    final authService = Provider.of<AuthService>(context, listen: false);

    final itemsEme = <ItemBotonEme>[
      ItemBotonEme(
          FontAwesomeIcons.shieldAlt,
          'Seguridad',
          Color.fromARGB(255, 3, 23, 35),
          Color.fromARGB(255, 68, 129, 228), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          var res = await emeCtrl.registroEmergencias(1);
          if (res == 'OK') {
            NotificationsService.showSnackbar('Emergencia!',
                "Sea registrado una emergencia.", ContentType.success);
          } else {
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión  a internet",
                ContentType.failure);
          }
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
      ItemBotonEme(
          FontAwesomeIcons.phoneSquare,
          '911',
          const Color.fromARGB(255, 90, 31, 226),
          const Color.fromARGB(255, 201, 133, 212), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          var res = await emeCtrl.registroEmergencias(2);
          if (res == 'OK') {
            NotificationsService.showSnackbar('Emergencia!',
                "Sea registrado una emergencia.", ContentType.success);
          } else {
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión  a internet",
                ContentType.failure);
          }
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
      ItemBotonEme(
          FontAwesomeIcons.userNurse,
          'Médica',
          const Color.fromARGB(255, 70, 109, 236),
          const Color.fromARGB(255, 117, 221, 145), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          var res = await emeCtrl.registroEmergencias(3);
          if (res == 'OK') {
            NotificationsService.showSnackbar('Emergencia!',
                "Sea registrado una emergencia.", ContentType.success);
          } else {
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión  a internet",
                ContentType.failure);
          }
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
      ItemBotonEme(
          FontAwesomeIcons.fireExtinguisher,
          'Incendio',
          Color.fromARGB(255, 240, 122, 122),
          Color.fromARGB(255, 222, 175, 20), () async {
        var conx = await authService.internetConnectivity();
        if (conx) {
          var res = await emeCtrl.registroEmergencias(4);
          if (res == 'OK') {
            NotificationsService.showSnackbar('Emergencia!',
                "Sea registrado una emergencia.", ContentType.success);
          } else {
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión  a internet",
                ContentType.failure);
          }
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión  a internet",
              ContentType.failure);
        }
      }),
    ];

    var itemMap = itemsEme.map((item) {
      return FadeInLeft(
        child: BotonGordoEmeTipo(
          iconR: item.icon,
          iconL: FontAwesomeIcons.bell,
          texto: item.texto,
          color1: item.color1,
          color2: item.color2,
          onPress: item.onPress,
        ),
      );
    }).toList();

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
            floating: true,
            delegate: _SliverCustomHeaderDelegate(
                minHeight: 150,
                maxHeight: 160,
                child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    child: _Titulo()))),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Column(
              children: [
                Text(
                  'POR NINGÚN MOTIVO ESTAS ALERTAS REMPLAZAN EL LLAMADO AL 911.',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Todas las alertas por emergencia van dirigidas a la guardia.',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 15,
                ),
                Obx(
                  () => emeCtrl.isLoading.isFalse
                      ? Column(
                          children: <Widget>[...itemMap],
                        )
                      : CircularProgressIndicator(
                          strokeWidth: 10,
                          color: Colors.red,
                        ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ]))
      ],
    );
  }
}

class _SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverCustomHeaderDelegate(
      {required this.minHeight, required this.maxHeight, required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent =>
      (this.minHeight > this.maxHeight) ? this.minHeight : this.maxHeight;

  @override
  // TODO: implement minExtent
  double get minExtent =>
      (this.maxHeight > this.minHeight) ? this.maxHeight : this.minHeight;

  @override
  bool shouldRebuild(covariant _SliverCustomHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _Titulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 0),
        SafeArea(
          child: Container(
              color: Colors.white,
              //  margin: EdgeInsets.only(top: 200),
              child: Hero(
                tag: Text('EMERGENCIAS'),
                child: BotonGordoNoti(
                  iconL: FontAwesomeIcons.bell,
                  iconR: FontAwesomeIcons.broadcastTower,
                  texto: 'EMERGENCIAS',
                  color1: Color.fromARGB(255, 219, 27, 27),
                  color2: Color.fromARGB(255, 237, 28, 129),
                  onPress: () => Navigator.of(context).pop(),
                ),
              )),
        ),
      ],
    );
  }
}

BoxDecoration _buildDecoration() {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(25)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 5),
            blurRadius: 5)
      ]);
}

void _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    NotificationsService.showSnackbar(
        'Oh! ',
        'Intentolo mas tarde o sComUnicarse con Administración',
        ContentType.failure);
  }
  ;
}
