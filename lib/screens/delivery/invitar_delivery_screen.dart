import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unikey/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/controllers.dart';
import '../../services/services.dart';
import '../../ui/input_decorations.dart';

class InvitarDeliveryScreen extends StatefulWidget {
  @override
  State<InvitarDeliveryScreen> createState() => _InvitarScreenState();
}

class _InvitarScreenState extends State<InvitarDeliveryScreen> {
  int currentStep = 0;
  DateTime? date;
  DateTimeRange? dateRange;
  String? email;
  String autorizoA = "";

  final items = ['2hrs', '3hrs', '4hrs', '5hrs'];
  String? valueVigencia;
  bool isCompleted = false;
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
              tag: Text('Delivery,Entregas,otros'),
              child: BotonGordo(
                iconL: FontAwesomeIcons.taxi,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Delivery,Entregas,otros',
                color1: Color.fromARGB(255, 105, 245, 203),
                color2: Color.fromARGB(255, 129, 95, 232),
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
                      final deliveryService = Get.find<DeliveryController>();

                      final response =
                          await deliveryService.postRegistroDelivery(
                              3,
                              DateTime.now(),
                              DateTime.now(),
                              valueVigencia,
                              autorizoA,
                              email);

                      if (response.contains('Error')) {
                        NotificationsService.showSnackbar(
                            'Oh! Ocurrio un problema',
                            response,
                            ContentType.failure);
                      } else {
                        await deliveryService.getTopDeli();
                        Navigator.pop(context);
                      }
                    } else
                      NotificationsService.showMyDialogAndroid(
                          context,
                          'No se pudo conectar a intenet',
                          'Debe asegurarse que el dipositivo tengo conexion a internet');
                    setState(() => isCompleted = false);
                  } else {
                    if (currentStep == 1 && autorizoA.isEmpty) {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          'Debes escribir a quien autorizas.',
                          ContentType.help);
                    } else if (currentStep == 2 && valueVigencia == null) {
                      NotificationsService.showSnackbar('Oh!',
                          'Debes seleccionar la vigencia.', ContentType.help);
                    } else {
                      setState(() => currentStep += 1);
                    }
                  }
                },
                onStepTapped: (step) {
                  if (currentStep == 1 && autorizoA.isEmpty) {
                    NotificationsService.showSnackbar('Oh!',
                        'Debes escribir a quien autorizas.', ContentType.help);
                  } else if (currentStep == 2 && valueVigencia == null) {
                    NotificationsService.showSnackbar('Oh!',
                        'Debes seleccionar la vigencia.', ContentType.help);
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
                    margin: EdgeInsets.only(top: 50),
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
                                            image: AssetImage(
                                                'assets/loading.gif'),
                                          ),
                                    Text(isLastStep ? 'ENVIAR' : 'SIGUIENTE'),
                                  ],
                                ),
                                onPressed: !isCompleted
                                    ? details.onStepContinue
                                    : null)),
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
        ]),
      ),
    );
  }

  List<Step> _getSteps() {
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
              'Invitar: Servicios de entragas rapidas,por ejemplo: Delivery,Farnacia,Local de Comida. Presiones CONTINUAR',
              style: TextStyle(color: Colors.black),
            ),
          )),
      Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text('Autorizo a:'),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: TextFormField(
              maxLength: 190,
              maxLines: 2,
              //maxLines: 1,
              style: TextStyle(color: Colors.black),
              onChanged: (value) => this.autorizoA = value,
            ),
          )),
      Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text('Vigencia'),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Container(
                width: double.infinity,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: valueVigencia,
                  hint: Text("Seleccion la Vigencia"),
                  iconSize: 36,
                  icon: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.black,
                  ),
                  items: items.map(_buildMenuItem).toList(),
                  onChanged: (value) =>
                      setState(() => this.valueVigencia = value),
                )),
          )),
      Step(
          isActive: currentStep >= 2,
          title: Text('Email (Campo opcional)'),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Campo opcional.',
              ),
              //maxLines: 1,
              style: TextStyle(color: Colors.black),
              onChanged: (value) => this.email = value,
            ),
          )),
    ];
  }

  DropdownMenuItem<String> _buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}
