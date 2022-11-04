import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDialogBox extends StatelessWidget {
  const CustomDialogBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10)
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Reservas',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Deportivas'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
              ElevatedButton(
                  onPressed: () => {},
                  child: const Text('Gastronomicas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ))
            ],
          ),
        ),
        const Positioned(
            left: 20,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 45,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(45)),
                  child: FaIcon(
                    FontAwesomeIcons.solidRegistered,
                    size: 90,
                    color: Colors.blue,
                  )),
            ))
      ],
    );
  }
}
