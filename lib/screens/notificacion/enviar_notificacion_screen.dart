import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/controllers.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';
import '../../ui/input_decorations.dart';

class EnviarNotificacionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificaiconesCtrl = Get.put(NotificacionController());

    return SafeArea(
      child: ScaffoldBody(),
    );
  }
}

class ScaffoldBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificaiconesCtrl = Get.find<NotificacionController>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            Background(color1: Color(0xff6989F5), color2: Colors.white),
            _MainScroll()
          ],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndDocked,
        floatingActionButton: ButtonTheme(
          minWidth: size.width * 0.2,
          height: 50,
          child: MaterialButton(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50))),
            child: notificaiconesCtrl.isSaving.value
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text('GUARDAR', style: TextStyle(color: Colors.white)),
            onPressed: notificaiconesCtrl.isSaving.value
                ? () {}
                : () async {
                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    var conx = await authService.internetConnectivity();
                    if (conx) {
                      if (!notificaiconesCtrl.isValidForm()) return;

                      notificaiconesCtrl.isSaving.value = true;
                      print('llego');
                      notificaiconesCtrl.isSaving.value = false;
                    } else
                      NotificationsService.showMyDialogAndroid(
                          context,
                          'No se pudo conectar a intenet',
                          'Debe asegurarse que el dipositivo tengo conexion a internet');
                  },
          ),
        ));
  }
}

class _MainScroll extends StatelessWidget {
  const _MainScroll({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mascotaCtrl = Get.find<NotificacionController>();

    TextEditingController eviarAController = new TextEditingController();
    return Obx(() => CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                floating: true,
                delegate: _SliverCustomHeaderDelegate(
                    minHeight: 150,
                    maxHeight: 160,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.white,
                        child: _Titulo()))),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Seleccione el modo a enviar:',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: AnimatedToggleSwitch<bool>.dual(
                  current: mascotaCtrl.enviaA.value,
                  first: false,
                  second: true,
                  dif: 50.0,
                  borderColor: Colors.transparent,
                  borderWidth: 5.0,
                  height: 55,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1.5),
                    ),
                  ],
                  onChanged: (b) => mascotaCtrl.enviaA.value = b,
                  colorBuilder: (b) => b ? Colors.blue : Colors.green,
                  iconBuilder: (value) => value
                      ? Icon(Icons.people_outline)
                      : Icon(Icons.all_inclusive),
                  textBuilder: (value) => value
                      ? Center(
                          child: Text(
                          'Grupo Familiar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                      : Center(
                          child: Text('Todos',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: _buildDecoration(),
                  child: Form(
                    key: mascotaCtrl.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        mascotaCtrl.enviaA.value
                            ? TextFormField(
                                controller: eviarAController,
                                onTap: () async {
                                  print('TO DO SEARCH');
                                },
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecorations.authInputDecoration(
                                    hintText: 'Seleccione un usuario',
                                    labelText:
                                        'Seleccione un ususario del grupo familiar'),
                                validator: (value) {
                                  if (value == null || value.length < 1) {
                                    return 'Debe seleccionar un usuario';
                                  }
                                })
                            : Text(''),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          maxLength: 50,
                          validator: (value) {
                            if (value == null || value.length < 1) {
                              return 'El titulo es obligatorio';
                            }
                          },
                          onChanged: (value) {
                            if (double.tryParse(value) == null) {
                            } else {}
                          },
                          decoration: InputDecorations.authInputDecoration(
                              hintText: 'Titulo de la notificación',
                              labelText: 'Titulo'),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          maxLines: 10,
                          maxLength: 250,
                          validator: (value) {
                            if (value == null || value.length < 1) {
                              return 'El cuerpo de la notificacion es obligatorio';
                            }
                          },
                          onChanged: (value) {
                            if (double.tryParse(value) == null) {
                            } else {}
                          },
                          decoration: InputDecorations.authInputDecoration(
                              hintText: 'Cuerpo de la notificación',
                              labelText: 'Notificación'),
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
                ),
              )
            ]))
          ],
        ));
  }
}

class _SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverCustomHeaderDelegate(
      {required this.minHeight, required this.maxHeight, required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent =>
      (this.minHeight > this.maxHeight) ? this.minHeight : this.maxHeight;

  @override
  // TODO: implement minExtent
  double get minExtent =>
      (this.maxHeight > this.minHeight) ? this.maxHeight : this.minHeight;

  @override
  bool shouldRebuild(covariant _SliverCustomHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class _Titulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 0),
        SafeArea(
          child: Container(
              color: Colors.white,
              //  margin: EdgeInsets.only(top: 200),
              child: Hero(
                tag: Text('Notificaciones'),
                child: BotonGordoNoti(
                  iconL: FontAwesomeIcons.bell,
                  iconR: FontAwesomeIcons.chevronLeft,
                  texto: 'Crear Notificación',
                  color1: Color.fromARGB(255, 105, 245, 203),
                  color2: Color.fromARGB(255, 129, 95, 232),
                  onPress: () => Navigator.of(context).pop(),
                ),
              )),
        ),
      ],
    );
  }
}

BoxDecoration _buildDecoration() {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(25)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 5),
            blurRadius: 5)
      ]);
}
