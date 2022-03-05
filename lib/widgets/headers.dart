import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconHeader extends StatelessWidget {
  final IconData icon;
  final String name;
  final String apellido;
  final String email;
  final String rol;
  final String lote;
  final String country;
  final Color color1;
  final Color color2;

  const IconHeader(
      {Key? key,
      required this.icon,
      this.color1 = Colors.blue,
      this.color2 = Colors.white,
      required this.name,
      required this.apellido,
      required this.email,
      required this.rol,
      required this.lote,
      required this.country})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color colorBlanco = Colors.white;
    return Stack(children: [
      _IconHeaderBackground(color1: this.color1, color2: this.color2),
      Positioned(
          top: -50,
          left: -70,
          child: FaIcon(
            this.icon,
            size: 250,
            color: Colors.white.withOpacity(0.2),
          )),
      Column(
        children: [
          SizedBox(
            height: 80,
            width: double.infinity,
          ),
          Text(
            this.country,
            style: TextStyle(
                fontSize: 40, color: colorBlanco, fontWeight: FontWeight.bold),
          ),
          Text(
            '${this.name.toUpperCase()} ${this.apellido.toUpperCase()}',
            style: TextStyle(fontSize: 20, color: colorBlanco),
          ),
          Text(
            '${this.rol} - Lote: ${this.lote}',
            style: TextStyle(fontSize: 20, color: colorBlanco),
          ),
          Text(
            '${this.email}',
            style: TextStyle(fontSize: 20, color: colorBlanco),
          ),
          SizedBox(
            height: 20,
          ),
          FaIcon(
            this.icon,
            size: 80,
            color: Colors.white,
          )
        ],
      )
    ]);
  }
}

class _IconHeaderBackground extends StatelessWidget {
  final Color color1;
  final Color color2;

  const _IconHeaderBackground(
      {Key? key, required this.color1, required this.color2})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[this.color1, this.color2])),
    );
  }
}
