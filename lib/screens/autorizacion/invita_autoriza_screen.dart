import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unica/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/services.dart';

class InvitaAutorizaScreen extends StatefulWidget {
  @override
  State<InvitaAutorizaScreen> createState() => _InvitarScreenState();
}

class _InvitarScreenState extends State<InvitaAutorizaScreen> {
  int currentStep = 0;
  DateTime? date;
  DateTimeRange? dateRange;
  String? value;
  bool isCompleted = false;

  String? comentarios;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Background(color1: Color(0xff6989F5), color2: Colors.white),
          Container(
            //  margin: EdgeInsets.only(top: 200),
            child: Hero(
              tag: 'Autorizaciones',
              child: BotonGordo(
                iconL: FontAwesomeIcons.idCardAlt,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Crear Autorización',
                color1: const Color.fromARGB(255, 70, 109, 236),
                color2: const Color.fromARGB(255, 117, 221, 145),
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
                  colorScheme: ColorScheme.light(primary: Colors.green)),
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
                      final authService =
                          Provider.of<AutService>(context, listen: false);

                      final response = await authService.postRegistroInvitacion(
                          1, dateRange!.start, dateRange!.end, comentarios);

                      if (response.contains('Error')) {
                        NotificationsService.showSnackbar(
                            'Oh!', response, ContentType.failure);
                      } else {
                        await Share.share(response);
                        await authService.getTopAut();

                        Navigator.pop(context);
                      }
                    } else
                      NotificationsService.showSnackbar(
                          'Oh!',
                          "Debe asegurarse que el dipositivo tenga conexión a internet",
                          ContentType.failure);
                  } else {
                    if (currentStep == 1 && dateRange == null) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'Debe seleccionar el rango de fecha.',
                          ContentType.help);
                    } else {
                      setState(() => currentStep += 1);
                    }
                  }
                  setState(() => isCompleted = false);
                },
                onStepTapped: (step) {
                  if (currentStep == 1 && dateRange == null) {
                    NotificationsService.showSnackbar(
                        'Oh!',
                        'Debe seleccionar el rango de fecha.',
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
              'Debe seleccionar el rango de fecha para la invitación. Presiones CONTINUAR',
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
                      'Seleccione las fechas',
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
/*       Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text('Forma de llegar'),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Container(
                width: double.infinity,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: value,
                  iconSize: 36,
                  icon: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.black,
                  ),
                  items: items.map(_buildMenuItem).toList(),
                  onChanged: (value) => setState(() => this.value = value),
                )),
          )), */
      Step(
          isActive: currentStep >= 2,
          title: const Text('Comentarios'),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: TextFormField(
              //maxLines: 1,
              onChanged: (value) => this.comentarios = value,

              style: const TextStyle(color: Colors.black),
            ),
          )),
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
        helpText: "Seleccione las fechas",
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

  DropdownMenuItem<String> _buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}
