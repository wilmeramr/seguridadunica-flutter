import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unikey/extension/timeofday.dart';
import 'package:Unikey/widgets/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';
import '../../ui/input_decorations.dart';

class InvitarEventoScreen extends StatefulWidget {
  @override
  State<InvitarEventoScreen> createState() => _InvitarEventoScreenState();
}

class _InvitarEventoScreenState extends State<InvitarEventoScreen> {
  int currentStep = 0;
  DateTime? dtdesde;
  DateTime? dthasta;
  String? comentarios;
  String autorizoA = "";
  String cantInvitados = "0";

  String? valueVigencia;
  bool isCompleted = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          const Background(color1: Color(0xff6989F5), color2: Colors.white),
          Container(
            //  margin: EdgeInsets.only(top: 200),
            child: Hero(
              tag: const Text('Eventos'),
              child: BotonGordo(
                iconL: FontAwesomeIcons.calendarAlt,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Eventos',
                color1: const Color.fromARGB(255, 45, 56, 207),
                color2: const Color.fromARGB(255, 39, 142, 108),
                onPress: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.only(top: 150),
            child: SingleChildScrollView(
                child: Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(primary: Colors.green)),
              child: Stepper(
                physics: const ClampingScrollPhysics(),
                steps: _getSteps(),
                currentStep: currentStep,
                onStepContinue: () async {
                  final isLastStep = currentStep == _getSteps().length - 1;
                  if (isLastStep) {
                    setState(() => isCompleted = true);

                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    var conx = await authService.internetConnectivity();
                    if (conx) {
                      final eventoCtrl = Get.find<EventoController>();

                      final response = await eventoCtrl.postRegistroEvento(
                          4,
                          dtdesde!,
                          dthasta!,
                          cantInvitados,
                          autorizoA,
                          comentarios);

                      if (response.contains('Error')) {
                        NotificationsService.showSnackbar(
                            'Oh!', response, ContentType.failure);
                      } else {
                        await eventoCtrl.getTopEvento();
                        Navigator.pop(context);
                      }
                    } else
                      NotificationsService.showSnackbar(
                          'Oh!',
                          "Debe asegurarse que el dipositivo tengo conexion a internet",
                          ContentType.failure);
                    setState(() => isCompleted = false);
                  } else {
                    if (currentStep == 1 && autorizoA.isEmpty) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'Debes escribir a quien autorizas.',
                          ContentType.help);
                    } else if (currentStep == 2 &&
                        (dtdesde == null || dthasta == null)) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'Debes seleccionar las fechas desde y hasta.',
                          ContentType.help);
                    } else if (currentStep == 2 &&
                        dtdesde!
                            .add(const Duration(minutes: 20))
                            .isAfter(dthasta!)) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'El rango de fechas debe ser mayor a 20 minutos.',
                          ContentType.help);
                    } else if (currentStep == 3 &&
                        (cantInvitados.isEmpty || cantInvitados == '0')) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'Debe ingresar la cantidad de invitados.',
                          ContentType.help);
                    } else {
                      setState(() => currentStep += 1);
                    }
                  }
                },
                onStepTapped: (step) {
                  if (currentStep == 1 && autorizoA.isEmpty) {
                    NotificationsService.showSnackbar('Oh!',
                        'Debes escribir a quien autorizas.', ContentType.help);
                  } else if (currentStep == 2 &&
                      (dtdesde == null || dthasta == null)) {
                    NotificationsService.showSnackbar('Oh!',
                        'Debes seleccionar la vigencia.', ContentType.help);
                  } else if (currentStep == 2 &&
                      dtdesde!
                          .add(const Duration(minutes: 20))
                          .isAfter(dthasta!)) {
                    NotificationsService.showSnackbar(
                        'Oh!',
                        'El rango de fechas debe ser mayor a 20 minutos.',
                        ContentType.help);
                  } else if (currentStep == 3 &&
                      (cantInvitados.isEmpty || cantInvitados == '0')) {
                    NotificationsService.showSnackbar(
                        'Oh!',
                        'Debe ingresar la cantidad de invitados.',
                        ContentType.help);
                  } else {
                    setState(() => currentStep = step);
                  }
                },
                onStepCancel: currentStep == 0
                    ? null
                    : () => setState(() {
                          currentStep -= 1;
                          isCompleted = false;
                        }),
                controlsBuilder: (context, details) {
                  final isLastStep = currentStep == _getSteps().length - 1;
                  return Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    !isCompleted
                                        ? Container()
                                        : Image(
                                            width: size.width * 0.05,
                                            image: const AssetImage(
                                                'assets/loading.gif'),
                                          ),
                                    Text(isLastStep ? 'ENVIAR' : 'SIGUIENTE'),
                                  ],
                                ),
                                onPressed: !isCompleted
                                    ? details.onStepContinue
                                    : null)),
                        const SizedBox(
                          width: 12,
                        ),
                        if (currentStep != 0)
                          Expanded(
                              child: ElevatedButton(
                            child: const Text('VOLVER'),
                            onPressed: details.onStepCancel,
                          ))
                      ],
                    ),
                  );
                },
              ),
            )),
          ),
        ]),
      ),
    );
  }

  List<Step> _getSteps() {
    return [
      Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text('Información'),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: const Text(
              'Indique el fecha y horario del evento, cantidad de invitados. Presione CONTINUAR',
              style: TextStyle(color: Colors.black),
            ),
          )),
      Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text('Nombre del evento:'),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: TextFormField(
              maxLength: 190,
              maxLines: 2,
              //maxLines: 1,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) => this.autorizoA = value,
            ),
          )),
      Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text('Fecha y Hora'),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Column(
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 3,
                  color: Colors.blue,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Text(
                      'Desde: ${dtdesde == null ? '' : dtdesde?.toESdate()}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () async => await pickDateRange(context, 'D'),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  disabledColor: Colors.grey,
                  elevation: 3,
                  color: Colors.blue,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Text(
                      'Hasta: ${dthasta == null ? '' : dthasta?.toESdate()}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () async => await pickDateRange(context, 'H'),
                ),
              ],
            ),
          )),
      Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text('Cantidad de invitados:'),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: TextFormField(
              keyboardType: TextInputType.number,
              maxLength: 3,
              maxLines: 1,
              decoration: InputDecoration(hintText: '0'),
              //maxLines: 1,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) => this.cantInvitados = value,
            ),
          )),
      Step(
          isActive: currentStep >= 4,
          title: const Text('Comentarios (Campo opcional)'),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Campo opcional.',
              ),
              //maxLines: 1,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) => this.comentarios = value,
            ),
          )),
    ];
  }

  Future pickDateRange(BuildContext context, String rango) async {
    final initialDateRange =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());

    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        onChanged: (date) {}, onConfirm: (date) {
      if (rango == 'D')
        setState(() => dtdesde = date);
      else {
        setState(() => dthasta = date);
      }
    }, currentTime: rango == 'D' ? dtdesde : dthasta, locale: LocaleType.es);
  }

  DropdownMenuItem<String> _buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}
