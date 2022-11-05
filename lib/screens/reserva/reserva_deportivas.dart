import 'dart:async';

import 'package:Unica/controllers/controllers.dart';
import 'package:Unica/models/horarios_models.dart';
import 'package:Unica/models/treserva_models.dart';
import 'package:Unica/services/auth_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../services/notifications_service.dart';
import '../../widgets/widgets.dart';

late TipoReserva treserva;
Timer? _timer;
int _start = 5;

class ReservaDeportivas extends StatefulWidget {
  const ReservaDeportivas({Key? key}) : super(key: key);

  @override
  State<ReservaDeportivas> createState() => _ReservaDeportivasState();
}

class _ReservaDeportivasState extends State<ReservaDeportivas> {
  var deportivaCtrl = Get.find<DeportivasController>();

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    horarios();
  }

  void horarios() async {
    print('fun');
    await deportivaCtrl.getTopTHorarios();
  }

  @override
  void dispose() {
    _timer?.cancel();
    Get.delete<DeportivasController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DatePickerController _controller = DatePickerController();
    var deportivaCtrl = Get.find<DeportivasController>();

    treserva = ModalRoute.of(context)!.settings.arguments as TipoReserva;

    DateTime _selectedValue = DateTime.now();
    return Scaffold(
      body: Stack(
        children: [
          Background(color1: Color(0xff6989F5), color2: Colors.white),
          Obx(() => Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  _BotonGordo(),
                  _DatePicker(),
                  _ListUbicacion(),
                  deportivaCtrl.isLoadingHorarios.isTrue
                      ? CircularProgressIndicator(
                          color: Colors.red,
                        )
                      : Text(''),
                  Expanded(child: _ListHorarios()),
                ],
              )),
        ],
      ),
    );
  }
}

class _ListHorarios extends StatelessWidget {
  const _ListHorarios({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deportivaCtrl = Get.find<DeportivasController>();

    return Obx(() => deportivaCtrl.dataHorarios.isEmpty && _start > 0
        ? Column(
            children: [
              const LinearProgressIndicator(
                color: Colors.green,
              ),
              const Center(child: Text('Espere por favor')),
              const SizedBox(
                height: 10,
              )
            ],
          )
        : RefreshIndicator(
            edgeOffset: 130,
            onRefresh: () async {
              final authService =
                  Provider.of<AuthService>(context, listen: false);

              var conx = await authService.internetConnectivity();
              if (conx) {
                var result = await deportivaCtrl.getTopTHorarios();
                if (!result!.contains('OK')) {
                  NotificationsService.showSnackbar(
                      'Oh!', "$result", ContentType.failure);
                }
              } else {
                NotificationsService.showSnackbar(
                    'Oh!',
                    "Debe asegurarse que el dipositivo tenga conexión a internet",
                    ContentType.failure);
              }
            },
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: deportivaCtrl.dataHorarios.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        _HorariosButton(
                            horarioid: deportivaCtrl.dataHorarios[index]),
                      ],
                    ),
                  );
                }),
          ));
  }
}

class _ListUbicacion extends StatelessWidget {
  const _ListUbicacion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: treserva.cantidad,
          itemBuilder: (context, index) {
            int indx = index + 1;
            return Padding(
              padding: const EdgeInsets.all(10.0),
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
          }),
    );
  }
}

class _UbicacionButton extends StatelessWidget {
  final int index;

  const _UbicacionButton({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deportivaCtrl = Get.find<DeportivasController>();
    return GestureDetector(
      onTap: () async {
        deportivaCtrl.ubicacionSelected.value = index;

        deportivaCtrl.isLoadingHorarios.value = true;
        await deportivaCtrl.getTopTHorarios();
        deportivaCtrl.isLoadingHorarios.value = false;
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

class _HorariosButton extends StatelessWidget {
  final Horarios horarioid;

  const _HorariosButton({Key? key, required this.horarioid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deportivaCtrl = Get.find<DeportivasController>();
    return GestureDetector(
      onTap: () async {},
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Obx(
          () => ElevatedButton(
              onPressed: deportivaCtrl.isSaving.isTrue
                  ? null
                  : () async {
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      var conx = await authService.internetConnectivity();
                      if (conx) {
                        var result = await deportivaCtrl.PostReserva(horarioid);

                        if (!result.contains('OK')) {
                          NotificationsService.showSnackbar(
                              'Oh!', "$result", ContentType.failure);
                        }
                      } else {
                        NotificationsService.showSnackbar(
                            'Oh!',
                            "Debe asegurarse que el dipositivo tenga conexión a internet",
                            ContentType.failure);
                      }
                    },
              child: deportivaCtrl.isSaving.isTrue
                  ? CircularProgressIndicator()
                  : Text(
                      horarioid.range,
                      style: TextStyle(color: Colors.black),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    horarioid.noHabilitado == 0 ? Colors.white : Colors.red,
              )),
        ),
      ),
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
            ], onDateChange: (date) async {
          deportivaCtrl.fechaSelected.value = date;
          deportivaCtrl.isLoadingHorarios.value = true;
          await deportivaCtrl.getTopTHorarios();
          deportivaCtrl.isLoadingHorarios.value = false;
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
