import 'dart:ffi';

import 'package:Unica/controllers/selfie_controller.dart';
import 'package:Unica/widgets/widgets.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/services.dart';

final Uri _url = Uri.parse('https://flutter.dev');

class InicioSelfieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaffoldBodySelfie(),
    );
  }
}

class ScaffoldBodySelfie extends StatelessWidget {
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
    final selfieCtrl = Get.put(SelfieController());
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
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: Column(
              children: [
                Text(
                  'En esta opción podrás tomarte la selfie para el acceso el barrio por medio de reconocimiento de rostros',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () async {
                    var result = await selfieCtrl.getUrlPropietorio();

                    _launchUrl(result);
                  },
                  child: Obx(
                    () => selfieCtrl.isLoading.isFalse
                        ? Icon(
                            FontAwesomeIcons.photoVideo,
                            color: Colors.blue,
                            size: 130,
                          )
                        : CircularProgressIndicator(
                            strokeWidth: 10,
                            color: Colors.red,
                          ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Presione la Imagen',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 90,
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
                tag: Text('Selfie Propietario'),
                child: BotonGordoNoti(
                  iconL: FontAwesomeIcons.photoVideo,
                  iconR: FontAwesomeIcons.chevronLeft,
                  texto: 'Selfie Propietario',
                  color1: Color.fromARGB(255, 90, 31, 226),
                  color2: Color.fromARGB(255, 201, 133, 212),
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
  if (!await launchUrl(Uri.parse(url))) {
    NotificationsService.showSnackbar(
        'Oh! ',
        'Intentolo mas tarde o sComUnicarse con Administración',
        ContentType.failure);
  }
  ;
}
