import 'dart:math';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Color color1;
  final Color color2;

  const Background({Key? key, required this.color1, required this.color2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
          0.2,
          0.8
        ],
            colors: [
          this.color1,
          this.color2,
        ]));
    return Stack(
      children: [
        Container(
          decoration: boxDecoration,

          //Pinkbox
        ),
        // Positioned(top: -100, left: -30, child: _PinkBox())
      ],
    );
  }
}

class _PinkBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            gradient: LinearGradient(colors: [Colors.blue, Colors.white])),
      ),
    );
  }
}
