import 'package:flutter/material.dart';

class CardTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'invitar');
            },
            child: _SingleCard(
              color: Colors.blue,
              icon: Icons.border_all,
              text: 'Invitar',
            ),
          ),
          _SingleCard(
            color: Colors.pinkAccent,
            icon: Icons.car_rental,
            text: 'Autorizar Servicios',
          )
        ])
      ],
    );
  }
}

class _SingleCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _SingleCard(
      {Key? key, required this.icon, required this.color, required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      height: 180,
      decoration: BoxDecoration(
          color: Color.fromARGB(174, 250, 248, 248),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: this.color,
            child: Icon(
              this.icon,
              size: 35,
            ),
            radius: 30,
          ),
          Text(
            this.text,
            style: TextStyle(color: this.color, fontSize: 18),
          )
        ],
      ),
    );
  }
}
