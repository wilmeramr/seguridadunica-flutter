import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/servicio_tipos_models.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:time_range_picker/time_range_picker.dart';
import 'package:flutter_application_1/extension/timeofday.dart';
import '../services/services.dart';

class InvitarServicioScreen extends StatefulWidget {
  @override
  State<InvitarServicioScreen> createState() => _InvitarServicioScreenState();
}

class _InvitarServicioScreenState extends State<InvitarServicioScreen> {
  int currentStep = 0;
  DateTime? date;
  DateTimeRange? dateRange;
  List<ServicioTipos>? servicioTipos;
  ServicioTipos? valueServiciotipos;
  bool isCompleted = false;
  bool isActive = true;
  List<bool> _isActive = [false, false, false, false, false, false, false];

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
              tag: 'Servicios',
              child: BotonGordo(
                iconL: FontAwesomeIcons.taxi,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Crear Servicios',
                color1: Color(0xff6989F5),
                color2: Color(0xff906EF5),
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
                    final servicioService =
                        Provider.of<ServicioService>(context, listen: false);

                    final response =
                        await servicioService.postRegistroInvitacion(
                            2,
                            dateRange!.start,
                            dateRange!.end,
                            _isActive,
                            timeRanges,
                            valueServiciotipos);

                    if (response.contains('Error')) {
                      NotificationsService.showSnackbar(response);
                    } else {
                      await Share.share(response);

                      Navigator.pop(context);
                    }
                  } else {
                    if (currentStep == 1 && dateRange == null) {
                      NotificationsService.showSnackbar(
                          'Debe seleccionar el rango de fecha.');
                    } else if (currentStep == 2 && valueServiciotipos == null) {
                      NotificationsService.showSnackbar(
                          'Debe seleccionar el tipo del servicio');
                    } else if (currentStep == 3 && !_isActive.contains(true)) {
                      NotificationsService.showSnackbar(
                          'Debe activar un dia en los horarios');
                    } else {
                      setState(() => currentStep += 1);
                    }
                  }
                },
                onStepTapped: (step) {
                  if (currentStep < step) {
                    if (currentStep == 1 && dateRange == null) {
                      NotificationsService.showSnackbar(
                          'Debe seleccionar el rango de fecha.');
                    } else if (currentStep == 2 && valueServiciotipos == null) {
                      NotificationsService.showSnackbar(
                          'Debe seleccionar el tipo del servicio');
                    } else if (currentStep == 3 && !_isActive.contains(true)) {
                      NotificationsService.showSnackbar(
                          'Debe activar un dia en los horarios');
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
                    margin: EdgeInsets.only(top: 50),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          child: Text(isLastStep ? 'ENVIAR' : 'SIGUIENTE'),
                          onPressed: details.onStepContinue,
                        )),
                        SizedBox(
                          width: 12,
                        ),
                        if (currentStep != 0)
                          Expanded(
                              child: ElevatedButton(
                            child: Text('VOLVER'),
                            onPressed: details.onStepCancel,
                          ))
                      ],
                    ),
                  );
                },
              ),
            )),
          ),
          !isCompleted
              ? Container()
              : Positioned(
                  bottom: size.height * 0.2,
                  left: size.width * 0.4,
                  child: Image(
                    width: size.width * 0.3,
                    image: AssetImage('assets/loading.gif'),
                  ))
        ]),
      ),
    );
  }

  List<Step> _getSteps(BuildContext context) {
    return [
      Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text('Informacion'),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Text(
              'Debe seleccionar el rango de fecha y hora para el servicio. Presiones CONTINUAR',
              style: TextStyle(color: Colors.black),
            ),
          )),
      Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text('Seleccinar fechas'),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Text(
                      'Seleccione las fechas',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () async => await pickDateRange(context),
                ),
                SizedBox(
                  height: 10,
                ),
                dateRange == null
                    ? Container()
                    : Text(
                        '${_getText()} ',
                        style: TextStyle(fontSize: 16),
                      )
              ],
            ),
          )),
      Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text('Tipo de Servicio'),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Container(
                width: double.infinity,
                child: DropdownButtonFormField<ServicioTipos>(
                  hint: Text('Seleccione tipo de  servicio'),
                  isExpanded: true,
                  value: valueServiciotipos,
                  iconSize: 36,
                  icon: Icon(
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
          title: Text('Horarios'),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
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
          title: Text('Comentarios'),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: TextFormField(
              //maxLines: 1,
              style: TextStyle(color: Colors.black),
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
                'Miercoles : ${timeRanges[3].startTime.to24hours()} - ${timeRanges[3].endTime.to24hours()} '),
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
                'Sabado : ${timeRanges[6].startTime.to24hours()} - ${timeRanges[6].endTime.to24hours()} '),
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
        helpText: "Selecctione las fechas",
        cancelText: "Salir",
        confirmText: "Guardar",
        saveText: "Guardar");

    if (newDateRange == null) return;

    setState(() => dateRange = newDateRange);
  }

  String _getText() {
    if (dateRange == null) return "Seleccione fechas";

    return 'Desde: ${dateRange?.start.day}/${dateRange?.start.month}/${dateRange?.start.year} - '
        'Hasta: ${dateRange?.end.day}/${dateRange?.end.month}/${dateRange?.end.year}';
  }

  DropdownMenuItem<ServicioTipos> _buildMenuItem(ServicioTipos item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item.stpDescripcion,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}
