import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../controllers/controllers.dart';

class BotonGordoNoti extends StatelessWidget {
  final IconData iconR;
  final IconData iconL;

  final String texto;
  final Color color1;
  final Color color2;
  final Function()? onPress;

  const BotonGordoNoti(
      {Key? key,
      this.iconR = FontAwesomeIcons.nimblr,
      required this.texto,
      this.color1 = Colors.blue,
      this.color2 = Colors.white,
      this.onPress,
      this.iconL = FontAwesomeIcons.chevronRight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badgeCtrl = Get.find<BadgeController>();
    return GestureDetector(
      onTap: this.onPress,
      child: Stack(
        children: [
          _BotonGordoBackground(
              icon: this.iconR, color1: this.color1, color2: this.color2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 140,
                width: 40,
              ),
              FaIcon(
                this.iconR,
                color: Colors.white,
                size: 40,
              ),
              Obx(() => badgeCtrl.badge.value > 0
                  ? Badge(
                      badgeContent: Text('${badgeCtrl.badge.value}'),
                    )
                  : Text('')),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  this.texto,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              FaIcon(
                this.iconL,
                color: Colors.white,
              ),
              SizedBox(
                width: 40,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _BotonGordoBackground extends StatelessWidget {
  final IconData icon;
  final Color color1;
  final Color color2;

  const _BotonGordoBackground({
    Key? key,
    required this.icon,
    required this.color1,
    required this.color2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Positioned(
                  right: -20,
                  top: -20,
                  child: FaIcon(
                    this.icon,
                    size: 150,
                    color: Colors.white.withOpacity(0.2),
                  ))
            ],
          ),
        ),
        width: double.infinity,
        height: 100,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(4, 6),
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(colors: [this.color1, this.color2])));
  }
}
