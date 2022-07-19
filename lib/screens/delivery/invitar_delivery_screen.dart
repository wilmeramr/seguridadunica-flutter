import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unica/widgets/widgets.dart';
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

  final items = ['30min', '35min', '40min', '45min', '50min', '1hrs'];
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
              tag: const Text('Delivery,Entregas,otros'),
              child: BotonGordo(
                iconL: FontAwesomeIcons.taxi,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Delivery,Entregas,otros',
                color1: const Color.fromARGB(255, 215, 8, 8),
                color2: const Color.fromARGB(255, 129, 95, 232),
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
                            'Oh!', response, ContentType.failure);
                      } else {
                        await deliveryService.getTopDeli();
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
              'Podrás invitar: Servicios de entragas rápidas,por ejemplo: Delivery,Farmacia,Local de Comida. Presione CONTINUAR',
              style: TextStyle(color: Colors.black),
            ),
          )),
      Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text('Autorizo a:'),
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
          title: const Text('Vigencia'),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: const BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Container(
                width: double.infinity,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: valueVigencia,
                  hint: const Text("Seleccione la Vigencia"),
                  iconSize: 36,
                  icon: const Icon(
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
          title: Text('E-mail (Campo opcional)'),
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
              onChanged: (value) => this.email = value,
            ),
          )),
    ];
  }

  DropdownMenuItem<String> _buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}
