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

class ItemBotonReservaTipo {
  final IconData icon;
  final String texto;
  final Color color1;
  final Color color2;
  final Function()? onPress;

  ItemBotonReservaTipo(
      this.icon, this.texto, this.color1, this.color2, this.onPress);
}

class ReservaTipoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldBodyReservaTipo();
  }
}

class ScaffoldBodyReservaTipo extends StatelessWidget {
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
    final authService = Provider.of<AuthService>(context, listen: false);

    final itemsEme = <ItemBotonReservaTipo>[
      ItemBotonReservaTipo(
          FontAwesomeIcons.baseballBall,
          'Deportivas',
          Color.fromARGB(255, 20, 147, 225),
          Color.fromARGB(255, 68, 129, 228), () async {
        Navigator.pushNamed(context, 'tipobyReservas', arguments: 1);
      }),
      ItemBotonReservaTipo(
          FontAwesomeIcons.pizzaSlice,
          'Gastronómicos',
          const Color.fromARGB(255, 90, 31, 226),
          const Color.fromARGB(255, 201, 133, 212),
          () async {}),
      ItemBotonReservaTipo(
          FontAwesomeIcons.swimmingPool,
          'Amenities',
          const Color.fromARGB(255, 70, 109, 236),
          const Color.fromARGB(255, 117, 221, 145),
          () async {}),
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
                minHeight: 250,
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
                const Text(
                  'Seleccione un tipo de reserva:',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: <Widget>[...itemMap],
                ),
                const SizedBox(
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
                tag: const Text('Reservas'),
                child: BotonGordoNoti(
                  iconL: FontAwesomeIcons.solidRegistered,
                  iconR: FontAwesomeIcons.chevronLeft,
                  texto: 'Reservas',
                  color1: const Color.fromARGB(255, 45, 199, 207),
                  color2: const Color.fromARGB(255, 33, 54, 131),
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
