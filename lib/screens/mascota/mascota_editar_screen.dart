import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Unikey/extension/timeofday.dart';
import 'package:Unikey/models/masc_genero_models.dart';
import 'package:Unikey/ui/input_decorations.dart';
import 'package:Unikey/widgets/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../models/masc_esp_models.dart';
import '../../services/services.dart';

class MascotaEditarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mascotaCtrl = Get.put(MascotaController());
    final mascotaFormCtrl =
        Get.put(MascotaFormController(mascotaCtrl.mascotaSelected!));

    return SafeArea(
      child: _MascotaScreenBody(mascotaCtrl: mascotaCtrl),
    );
  }
}

class _MascotaScreenBody extends StatelessWidget {
  const _MascotaScreenBody({
    Key? key,
    required this.mascotaCtrl,
  }) : super(key: key);

  final MascotaController mascotaCtrl;

  @override
  Widget build(BuildContext context) {
    final mascotaFormCtrl = Get.find<MascotaFormController>();
    final size = MediaQuery.of(context).size;
    return Obx(() => Scaffold(
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                Background(color1: Color(0xff6989F5), color2: Colors.white),
                Container(
                  //  margin: EdgeInsets.only(top: 200),
                  child: Hero(
                    tag: Text('Mascotas'),
                    child: BotonGordo(
                      iconL: FontAwesomeIcons.paw,
                      iconR: FontAwesomeIcons.chevronLeft,
                      texto: 'Mascotas',
                      color1: Color(0xffF2D572),
                      color2: Color(0xffE06AA3),
                      onPress: () {
                        Get.delete<MascotaFormController>();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Obx(() => MascotaImage(
                        url: mascotaCtrl.mascotaSelected?.value.mascUrlFoto)),
                    Positioned(
                        top: 60,
                        right: 20,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt_outlined,
                              size: 40, color: Colors.white),
                          onPressed: () async {
                            await _showChoiceDialog(context);
                            if (mascotaCtrl.galleryOCamare == 0) {
                              return;
                            }
                            if (mascotaCtrl.galleryOCamare == 1) {
                              var pickedFile = await _openGallery();
                              mascotaCtrl.galleryOCamare.value = 0;

                              if (pickedFile == null) return;

                              mascotaCtrl.mascotaSelected?.update((val) {
                                val?.mascUrlFoto = pickedFile.path;
                              });
                              mascotaCtrl.mascotaSelected?.refresh();
                              mascotaFormCtrl
                                  .updateSelectedMascotaImage(pickedFile.path);
                            }
                            if (mascotaCtrl.galleryOCamare == 2) {
                              var pickedFile = await _openCamera();
                              mascotaCtrl.galleryOCamare.value = 0;

                              if (pickedFile == null) return;

                              mascotaCtrl.mascotaSelected?.update((val) {
                                val?.mascUrlFoto = pickedFile.path;
                              });
                              mascotaCtrl.mascotaSelected?.refresh();
                              mascotaFormCtrl
                                  .updateSelectedMascotaImage(pickedFile.path);
                            }
                          },
                        )),
                  ],
                ),
                _ProductForm(),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndDocked,
          floatingActionButton: ButtonTheme(
            minWidth: size.width * 0.2,
            height: 50,
            child: MaterialButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(50))),
              child: mascotaFormCtrl.isSaving.value
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text('GUARDAR', style: TextStyle(color: Colors.white)),
              onPressed: mascotaFormCtrl.isSaving.value
                  ? () {}
                  : () async {
                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      var conx = await authService.internetConnectivity();
                      if (conx) {
                        if (!mascotaFormCtrl.isValidForm()) return;

                        mascotaFormCtrl.isSaving.value = true;
                        final String? imageUrl =
                            await mascotaFormCtrl.uploadImage();
                        if (imageUrl != null) {
                          mascotaFormCtrl.mascota.value.mascUrlFoto = imageUrl;
                        }

                        var result =
                            await mascotaFormCtrl.saveOrCreateMascota();
                        mascotaFormCtrl.isSaving.value = false;
                        if (result.contains('error')) {
                          NotificationsService.showMyDialogAndroid(
                              context, 'Mascota', result);
                          return;
                        }
                        if (result.contains('update')) {
                          mascotaCtrl.data.value =
                              mascotaCtrl.data.value.map((e) {
                            if (e.mascId ==
                                mascotaFormCtrl.mascota.value.mascId) {
                              e = mascotaFormCtrl.mascota.value;
                            }
                            return e;
                          }).toList();
                        } else if (result.contains('create')) {
                          mascotaCtrl.mascotaSelected!.update((val) {
                            val?.mascId = int.parse(result.split(':')[1]);
                            mascotaCtrl.data
                                .insert(0, mascotaCtrl.mascotaSelected!.value);
                            mascotaCtrl.data.refresh();
                          });
                        }
                      } else
                        NotificationsService.showMyDialogAndroid(
                            context,
                            'No se pudo conectar a intenet',
                            'Debe asegurarse que el dipositivo tengo conexion a internet');
                    },
            ),
          ),
        ));
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mascotaCtrl = Get.find<MascotaController>();
    final mascotaFormCtrl = Get.find<MascotaFormController>();

    final mascota = mascotaFormCtrl.mascota;

    TextEditingController nacimientoController = new TextEditingController();
    nacimientoController.text =
        '${mascota.value.mascFechaNacimiento.toESdateTime()}';
    TextEditingController vacunacionController = new TextEditingController();
    vacunacionController.text =
        '${mascota.value.mascFechaVacunacion.toESdateTime()}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Obx(() => Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: _buildDecoration(),
            child: Form(
              key: mascotaFormCtrl.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: mascota.value.mascName,
                    validator: (value) {
                      if (value == null || value.length < 1) {
                        return 'El nombre es obligatorio';
                      }
                    },
                    onChanged: (value) => mascota.value.mascName = value,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Nombre de su mascota', labelText: 'Nombre'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  DropdownButtonFormField<Especy>(
                    elevation: 16,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Especie de su mascota',
                        labelText: 'Especie'),
                    value: mascotaCtrl.dataEspeccies
                        .where((element) =>
                            element.mascEspId == mascota.value.mascEspecieId)
                        .elementAt(0),
                    isExpanded: true,
                    // hint: Text("Seleccion la Especie"),
                    iconSize: 36,
                    icon: Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.black,
                    ),
                    items:
                        mascotaCtrl.dataEspeccies.map(_buildMenuItem).toList(),
                    onChanged: (item) {
                      mascota.update((val) {
                        val?.mascEspecieId = item == null ? 0 : item.mascEspId;
                      });
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    initialValue: mascota.value.mascRaza,
                    validator: (value) {
                      if (value == null || value.length < 1) {
                        return 'El raza es obligatorio';
                      }
                    },
                    onChanged: (value) => mascota.value.mascRaza = value,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Raza de su mascota', labelText: 'Raza'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  DropdownButtonFormField<Genero>(
                    elevation: 16,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Genero de su mascota', labelText: 'Genero'),
                    value: mascotaCtrl.datagenero
                        .where((element) =>
                            element.mascGeneId == mascota.value.mascGeneroId)
                        .elementAt(0),
                    isExpanded: true,
                    // hint: Text("Seleccion la Especie"),
                    iconSize: 36,
                    icon: Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.black,
                    ),
                    items: mascotaCtrl.datagenero
                        .map(_buildMenuItemGenero)
                        .toList(),
                    onChanged: (item) {
                      mascota.update((val) {
                        val?.mascGeneroId = item == null ? 0 : item.mascGeneId;
                      });
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    initialValue: '${mascota.value.mascPeso}',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    validator: (value) {
                      if (value == null || value.length < 1) {
                        return 'El nombre es obligatorio';
                      }
                    },
                    onChanged: (value) {
                      if (double.tryParse(value) == null) {
                        mascota.value.mascPeso = 0;
                      } else {
                        mascota.value.mascPeso = double.parse(value);
                      }
                    },
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Peso de su mascota', labelText: 'Peso (Kg)'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: nacimientoController,
                    onTap: () async {
                      var date = await pickDate(
                          context, mascota.value.mascFechaNacimiento);

                      if (date != null) {
                        mascota.update((val) {
                          val?.mascFechaNacimiento = date;
                        });
                        nacimientoController.text =
                            '${mascota.value.mascFechaNacimiento.toESdateTime()}';
                      }
                    },
                    readOnly: true,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Seleccione fecha',
                        labelText: 'Fecha Nacimiento'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: vacunacionController,
                    onTap: () async {
                      var date = await pickDate(
                          context, mascota.value.mascFechaVacunacion);

                      if (date != null) {
                        mascota.update((val) {
                          val?.mascFechaVacunacion = date;
                        });
                        vacunacionController.text =
                            '${mascota.value.mascFechaVacunacion.toESdateTime()}';
                      }
                    },
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        hintText: 'Seleccione fecha',
                        labelText: 'Ultima Vacunacion'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          )),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5)
        ]);
  }

  DropdownMenuItem<Especy> _buildMenuItem(Especy item) => DropdownMenuItem(
        value: item,
        child: Text(
          item.mascEspName,
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      );
  DropdownMenuItem<Genero> _buildMenuItemGenero(Genero item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item.mascGeneName,
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      );

  Future pickDate(BuildContext context, DateTime initialDate) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      helpText: "Selecctione la fecha de nacimiento",
      cancelText: "Salir",
      confirmText: "Guardar",
      firstDate: DateTime(2021),
      lastDate: DateTime(2050),
    );
    if (newDate == null) return;

    return newDate;
  }
}

Future<XFile?> _openGallery() async {
  final picker = new ImagePicker();
  final XFile? pickedFile =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

  return pickedFile;
}

Future<XFile?> _openCamera() async {
  final picker = new ImagePicker();
  final XFile? pickedFile =
      await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

  return pickedFile;
}

Future<void> _showChoiceDialog(BuildContext context) {
  final mascotaCtrl = Get.find<MascotaController>();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Seleccione modo:",
            style: TextStyle(color: Colors.blue),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(
                  height: 1,
                  color: Colors.blue,
                ),
                ListTile(
                  onTap: () {
                    mascotaCtrl.galleryOCamare.value = 1;
                    Navigator.pop(context);
                  },
                  title: Text("Galeria"),
                  leading: Icon(
                    Icons.account_box,
                    color: Colors.blue,
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.blue,
                ),
                ListTile(
                  onTap: () {
                    mascotaCtrl.galleryOCamare.value = 2;
                    Navigator.pop(context);
                  },
                  title: Text("Camara"),
                  leading: Icon(
                    Icons.camera,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
