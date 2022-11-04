import 'package:Unica/controllers/controllers.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../widgets/widgets.dart';

class ReservaDeportivas extends StatelessWidget {
  const ReservaDeportivas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deportivaCtrl = Get.put(DeportivasController());
    DatePickerController _controller = DatePickerController();

    DateTime _selectedValue = DateTime.now();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Background(color1: Color(0xff6989F5), color2: Colors.white),
            Column(
              children: [
                _BotonGordo(),
                _DatePicker(),
                Expanded(child: _ListUbicacion())
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ListUbicacion extends StatelessWidget {
  const _ListUbicacion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          int indx = index + 1;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _UbicacionButton(index: indx),
                SizedBox(
                  height: 5,
                ),
                Text('Cancha: $indx'),
              ],
            ),
          );
        });
  }
}

class _UbicacionButton extends StatelessWidget {
  final int index;

  const _UbicacionButton({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deportivaCtrl = Get.find<DeportivasController>();
    return GestureDetector(
      onTap: () {
        deportivaCtrl.ubicacionSelected.value = index;

        print(deportivaCtrl.ubicacionSelected.value);

        print(deportivaCtrl.fechaSelected.value);
      },
      child: Obx(() => Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: deportivaCtrl.ubicacionSelected.value == index
                    ? Colors.red
                    : Colors.white),
            child: Icon(FontAwesomeIcons.basketballBall),
          )),
    );

    //FaIcon(FontAwesomeIcons.basketballBall);
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deportivaCtrl = Get.find<DeportivasController>();

    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        color: Colors.white24,
        child: DatePicker(DateTime.now(),
            width: 60,
            height: 80,
            locale: 'es_AR',
            initialSelectedDate: DateTime.now(),
            selectionColor: Colors.black,
            selectedTextColor: Colors.white,
            activeDates: [
              DateTime.now(),
              DateTime.now().add(Duration(days: 1)),
            ], onDateChange: (date) {
          deportivaCtrl.fechaSelected.value = date;
        }));
  }
}

class _BotonGordo extends StatelessWidget {
  const _BotonGordo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BotonGordoNoti(
      iconL: FontAwesomeIcons.solidRegistered,
      iconR: FontAwesomeIcons.chevronLeft,
      texto: 'Reservas',
      color1: const Color.fromARGB(255, 45, 199, 207),
      color2: const Color.fromARGB(255, 33, 54, 131),
      onPress: () => Navigator.of(context).pop(),
    );
  }
}
