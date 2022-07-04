import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unikey/models/servicio_tipos_models.dart';
import 'package:Unikey/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:time_range_picker/time_range_picker.dart';
import 'package:Unikey/extension/timeofday.dart';
import '../../controllers/notificacion_controller.dart';
import '../../services/services.dart';

class InvitaServicioScreen extends StatefulWidget {
  @override
  State<InvitaServicioScreen> createState() => _InvitarServicioScreenState();
}

class _InvitarServicioScreenState extends State<InvitaServicioScreen> {
  int currentStep = 0;
  DateTime? date;
  DateTimeRange? dateRange;
  List<ServicioTipos>? servicioTipos;
  ServicioTipos? valueServiciotipos;
  bool isCompleted = false;
  bool isActive = true;
  List<bool> _isActive = [false, false, false, false, false, false, false];
  String? comentario;
  List<TimeRange> timeRanges = [
    TimeRange(
        startTime: TimeOfDay(hour: 00, minute: 00),
        endTime: TimeOfDay(hour: 23, minute: 59)),
    TimeRange(
        startTime: TimeOfDay(hour: 00, minute: 00),
        endTime: TimeOfDay(hour: 23, minute: 59)),
    TimeRange(
        startTime: TimeOfDay(hour: 00, minute: 00),
        endTime: TimeOfDay(hour: 23, minute: 59)),
    TimeRange(
        startTime: TimeOfDay(hour: 00, minute: 00),
        endTime: TimeOfDay(hour: 23, minute: 59)),
    TimeRange(
        startTime: TimeOfDay(hour: 00, minute: 00),
        endTime: TimeOfDay(hour: 23, minute: 59)),
    TimeRange(
        startTime: TimeOfDay(hour: 00, minute: 00),
        endTime: TimeOfDay(hour: 23, minute: 59)),
    TimeRange(
        startTime: TimeOfDay(hour: 00, minute: 00),
        endTime: TimeOfDay(hour: 23, minute: 59)),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final servicioService = Provider.of<ServicioService>(context);
    final data = servicioService.servicioTipos;
    servicioTipos = data; // data.map((e) => e.stpDescripcion).toList();
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Background(color1: Color(0xff6989F5), color2: Colors.white),
          Container(
            //  margin: EdgeInsets.only(top: 200),
            child: Hero(
              tag: 'Vistas recurrentes',
              child: BotonGordo(
                iconL: FontAwesomeIcons.taxi,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Vistas recurrentes',
                color1: Color(0xff317183),
                color2: Color.fromARGB(255, 152, 70, 153),
                onPress: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(top: 150),
            child: SingleChildScrollView(
                child: Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(primary: Colors.green)),
              child: Stepper(
                physics: ClampingScrollPhysics(),
                steps: _getSteps(context),
                currentStep: currentStep,
                onStepContinue: () async {
                  final isLastStep =
                      currentStep == _getSteps(context).length - 1;
                  if (isLastStep) {
                    setState(() => isCompleted = true);

                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    var conx = await authService.internetConnectivity();
                    if (conx) {
                      final servicioService =
                          Provider.of<ServicioService>(context, listen: false);

                      final response =
                          await servicioService.postRegistroInvitacion(
                              2,
                              dateRange!.start,
                              dateRange!.end,
                              _isActive,
                              timeRanges,
                              valueServiciotipos,
                              this.comentario);

                      if (response.contains('Error')) {
                        NotificationsService.showSnackbar(
                            'Oh!', response, ContentType.failure);
                      } else {
                        await Share.share(response);
                        await servicioService.getTopAut();

                        Navigator.pop(context);
                      }
                    } else
                      NotificationsService.showSnackbar(
                          'Oh!',
                          "Debe asegurarse que el dipositivo tengo conexion a internet",
                          ContentType.failure);
                  } else {
                    if (currentStep == 1 && dateRange == null) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'Debe seleccionar el rango de fecha.',
                          ContentType.help);
                    } else if (currentStep == 2 && valueServiciotipos == null) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'Debe seleccionar el tipo del servicio',
                          ContentType.help);
                    } else if (currentStep == 3 && !_isActive.contains(true)) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'Debe activar un dia en los horarios',
                          ContentType.help);
                    } else {
                      setState(() => currentStep += 1);
                    }
                  }
                  setState(() => isCompleted = false);
                },
                onStepTapped: (step) {
                  if (currentStep < step) {
                    if (currentStep == 1 && dateRange == null) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'Debe seleccionar el rango de fecha.',
                          ContentType.help);
                    } else if (currentStep == 2 && valueServiciotipos == null) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'Debe seleccionar el tipo del servicio',
                          ContentType.help);
                    } else if (currentStep == 3 && !_isActive.contains(true)) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'Debe activar un dia en los horarios',
                          ContentType.help);
                    } else {
                      setState(() => currentStep = step);
                    }
                  } else {
                    setState(() => currentStep -= 1);
                  }
                },
                onStepCancel: currentStep == 0
                    ? null
                    : () => setState(() {
                          currentStep -= 1;
                          isCompleted = false;
                        }),
                controlsBuilder: (context, details) {
                  final isLastStep =
                      currentStep == _getSteps(context).length - 1;
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
                          onPressed:
                              !isCompleted ? details.onStepContinue : null,
                        )),
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

  List<Step> _getSteps(BuildContext context) {
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
              'Debe seleccionar el rango de fecha y hora para el servicio. Presiones CONTINUAR',
              style: TextStyle(color: Colors.black),
            ),
          )),
      Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text('Seleccionar fechas'),
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
                    child: const Text(
                      "Seleccione las fechas",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () async => await pickDateRange(context),
                ),
                const SizedBox(
                  height: 10,
                ),
                dateRange == null
                    ? Container()
                    : Text(
                        '${_getText()} ',
                        style: const TextStyle(fontSize: 16),
                      )
              ],
            ),
          )),
      Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text('Tipo de visita recurrente'),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<ServicioTipos>(
                  hint: const Text('Seleccione tipo de visita recurrente'),
                  isExpanded: true,
                  value: valueServiciotipos,
                  iconSize: 36,
                  icon: const Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.black,
                  ),
                  items: servicioTipos?.map(_buildMenuItem).toList(),
                  onChanged: (value) =>
                      setState(() => this.valueServiciotipos = value),
                )),
          )),
      Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text('Horarios'),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Container(
                width: double.infinity,
                child: Column(
                  children: _horarioDias(context),
                )),
          )),
      Step(
          isActive: currentStep >= 4,
          title: const Text('Comentarios'),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: TextFormField(
              //maxLines: 1,
              onChanged: (value) => this.comentario = value,
              style: const TextStyle(color: Colors.black),
            ),
          )),
    ];
  }

  List<SwitchListTile> _horarioDias(BuildContext context) {
    final servicioService =
        Provider.of<ServicioService>(context, listen: false);
    return [
      SwitchListTile.adaptive(
          value: _isActive[0],
          title: FittedBox(
            child: Text(
                'Domingo: ${timeRanges[0].startTime.to24hours()} - ${timeRanges[0].endTime.to24hours()} '),
          ),
          onChanged: (value) async {
            if (value) {
              TimeRange? rsult = await showTimeRangePicker(
                  context: context,
                  fromText: 'Desde',
                  toText: 'Hasta',
                  start: timeRanges[0].startTime,
                  end: timeRanges[0].endTime);

              if (rsult != null) {
                _isActive[0] = value;
                timeRanges[0].startTime = rsult.startTime;
                timeRanges[0].endTime = rsult.endTime;
              }
            } else {
              _isActive[0] = value;
            }

            setState(() {});
          }),
      SwitchListTile.adaptive(
          value: _isActive[1],
          title: FittedBox(
            child: Text(
                'Lunes : ${timeRanges[1].startTime.to24hours()} - ${timeRanges[1].endTime.to24hours()} '),
          ),
          onChanged: (value) async {
            if (value) {
              TimeRange? rsult = await showTimeRangePicker(
                  context: context,
                  fromText: 'Desde',
                  toText: 'Hasta',
                  start: timeRanges[1].startTime,
                  end: timeRanges[1].endTime);
              if (rsult != null) {
                _isActive[1] = value;

                timeRanges[1].startTime = rsult.startTime;
                timeRanges[1].endTime = rsult.endTime;
              }
            } else {
              _isActive[1] = value;
            }

            setState(() {});
          }),
      SwitchListTile.adaptive(
          value: _isActive[2],
          title: FittedBox(
            child: Text(
                'Martes : ${timeRanges[2].startTime.to24hours()} - ${timeRanges[2].endTime.to24hours()} '),
          ),
          onChanged: (value) async {
            if (value) {
              TimeRange? rsult = await showTimeRangePicker(
                  context: context,
                  fromText: 'Desde',
                  toText: 'Hasta',
                  start: timeRanges[2].startTime,
                  end: timeRanges[2].endTime);
              if (rsult != null) {
                _isActive[2] = value;

                timeRanges[2].startTime = rsult.startTime;
                timeRanges[2].endTime = rsult.endTime;
              }
            } else {
              _isActive[2] = value;
            }

            setState(() {});
          }),
      SwitchListTile.adaptive(
          value: _isActive[3],
          title: FittedBox(
            child: Text(
                'Miércoles : ${timeRanges[3].startTime.to24hours()} - ${timeRanges[3].endTime.to24hours()} '),
          ),
          onChanged: (value) async {
            if (value) {
              TimeRange? rsult = await showTimeRangePicker(
                  context: context,
                  fromText: 'Desde',
                  toText: 'Hasta',
                  start: timeRanges[3].startTime,
                  end: timeRanges[3].endTime);
              if (rsult != null) {
                _isActive[3] = value;

                timeRanges[3].startTime = rsult.startTime;
                timeRanges[3].endTime = rsult.endTime;
              }
            } else {
              _isActive[3] = value;
            }

            setState(() {});
          }),
      SwitchListTile.adaptive(
          value: _isActive[4],
          title: FittedBox(
            child: Text(
                'Jueves : ${timeRanges[4].startTime.to24hours()} - ${timeRanges[4].endTime.to24hours()} '),
          ),
          onChanged: (value) async {
            if (value) {
              TimeRange? rsult = await showTimeRangePicker(
                  context: context,
                  fromText: 'Desde',
                  toText: 'Hasta',
                  start: timeRanges[4].startTime,
                  end: timeRanges[4].endTime);
              if (rsult != null) {
                _isActive[4] = value;

                timeRanges[4].startTime = rsult.startTime;
                timeRanges[4].endTime = rsult.endTime;
              }
            } else {
              _isActive[4] = value;
            }

            setState(() {});
          }),
      SwitchListTile.adaptive(
          value: _isActive[5],
          title: FittedBox(
            child: Text(
                'Viernes : ${timeRanges[5].startTime.to24hours()} - ${timeRanges[5].endTime.to24hours()} '),
          ),
          onChanged: (value) async {
            if (value) {
              TimeRange? rsult = await showTimeRangePicker(
                  context: context,
                  fromText: 'Desde',
                  toText: 'Hasta',
                  start: timeRanges[5].startTime,
                  end: timeRanges[5].endTime);
              if (rsult != null) {
                _isActive[5] = value;

                timeRanges[5].startTime = rsult.startTime;
                timeRanges[5].endTime = rsult.endTime;
              }
            } else {
              _isActive[5] = value;
            }

            setState(() {});
          }),
      SwitchListTile.adaptive(
          value: _isActive[6],
          title: FittedBox(
            child: Text(
                'Sábado : ${timeRanges[6].startTime.to24hours()} - ${timeRanges[6].endTime.to24hours()} '),
          ),
          onChanged: (value) async {
            if (value) {
              TimeRange? rsult = await showTimeRangePicker(
                  context: context,
                  fromText: 'Desde',
                  toText: 'Hasta',
                  start: timeRanges[6].startTime,
                  end: timeRanges[6].endTime);
              if (rsult != null) {
                _isActive[6] = value;

                timeRanges[6].startTime = rsult.startTime;
                timeRanges[6].endTime = rsult.endTime;
              }
            } else {
              _isActive[6] = value;
            }

            setState(() {});
          }),
    ];
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();

    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());

    final newDateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange: dateRange ?? initialDateRange,
        helpText: "Seleccioné las fechas",
        cancelText: "Salir",
        confirmText: "Guardar",
        saveText: "Guardar");

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }

  String _getText() {
    if (dateRange == null) return "Seleccioné fechas";

    return 'Desde: ${dateRange?.start.day}/${dateRange?.start.month}/${dateRange?.start.year} - '
        'Hasta: ${dateRange?.end.day}/${dateRange?.end.month}/${dateRange?.end.year}';
  }

  DropdownMenuItem<ServicioTipos> _buildMenuItem(ServicioTipos item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item.stpDescripcion,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}
