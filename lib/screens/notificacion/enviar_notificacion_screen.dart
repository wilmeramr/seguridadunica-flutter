import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unica/controllers/controllers.dart';
import 'package:Unica/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../search/usuario_delegate.dart';
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
          child: Obx(() => MaterialButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(50))),
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
                          var result =
                              await notificaiconesCtrl.RegistroNotificacion();

                          if (result == 'OK') {
                            NotificationsService.showSnackbar(
                                'Notificación',
                                "La notificacion fue enviada.",
                                ContentType.success);
                          } else {
                            NotificationsService.showSnackbar(
                                'Oh! ',
                                "La notificación no fue enviada, $result",
                                ContentType.failure);
                          }
                          notificaiconesCtrl.isSaving.value = false;
                        } else
                          NotificationsService.showSnackbar(
                              'Oh! Conexión a intenet',
                              "Debe asegurarse que el dipositivo tengo conexión a internet",
                              ContentType.failure);
                      },
              )),
        ));
  }
}

class _MainScroll extends StatelessWidget {
  const _MainScroll({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificacionCtrl = Get.find<NotificacionController>();

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
                  'Seleccione el modo a enviar: Todos / Grupo',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: AnimatedToggleSwitch<bool>.dual(
                  current: notificacionCtrl.enviaA.value,
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
                  onChanged: (b) {
                    notificacionCtrl.enviaA.value = b;
                    notificacionCtrl.initUsers();
                  },
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
                    key: notificacionCtrl.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        notificacionCtrl.enviaA.value
                            ? TextFormField(
                                controller: eviarAController,
                                onTap: () async {
                                  final authService = Provider.of<AuthService>(
                                      context,
                                      listen: false);

                                  var conx =
                                      await authService.internetConnectivity();
                                  if (conx) {
                                    showSearch(
                                        context: context,
                                        delegate: UsuarioSearchDelegate());
                                  } else
                                    NotificationsService.showSnackbar(
                                        'Oh! Conexión a intenet',
                                        "Debe asegurarse que el dipositivo tengo conexión a internet",
                                        ContentType.failure);
                                },
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecorations.authInputDecoration(
                                  labelText: notificacionCtrl
                                              .userIdSelected.value.usrId ==
                                          0
                                      ? 'Seleccione un usuario'
                                      : notificacionCtrl
                                              .userIdSelected.value.usrName +
                                          ' ' +
                                          notificacionCtrl
                                              .userIdSelected.value.usrApellido,
                                  hintText: notificacionCtrl
                                              .userIdSelected.value.usrId ==
                                          0
                                      ? 'Seleccione un usuario'
                                      : notificacionCtrl
                                          .userIdSelected.value.usEmail,
                                ),
                                validator: (value) {
                                  if (notificacionCtrl
                                          .userIdSelected.value.usrId ==
                                      0) {
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
                              return 'El título es obligatorio';
                            }
                          },
                          onChanged: (value) {
                            notificacionCtrl.titulo.value = value;
                          },
                          decoration: InputDecorations.authInputDecoration(
                              hintText: 'Título de la notificación',
                              labelText: 'Título'),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          maxLines: 10,
                          maxLength: 250,
                          validator: (value) {
                            if (value == null || value.length < 1) {
                              return 'El cuerpo de la notificación es obligatorio';
                            }
                          },
                          onChanged: (value) {
                            notificacionCtrl.body.value = value;
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
                  color1: Color.fromARGB(255, 27, 85, 219),
                  color2: Color.fromARGB(255, 28, 209, 237),
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
