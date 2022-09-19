import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:Unica/controllers/controllers.dart';
import 'package:Unica/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';
import '../../ui/input_decorations.dart';

class EnviarNoticiaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noticiaCtrl = Get.put(NoticiaController());

    return ScaffoldBodyNoticia();
  }
}

class ScaffoldBodyNoticia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noticiaCtrl = Get.find<NoticiaController>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            const Background(color1: Color(0xff6989F5), color2: Colors.white),
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
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(50))),
                child: noticiaCtrl.isSaving.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('GUARDAR',
                        style: TextStyle(color: Colors.white)),
                onPressed: noticiaCtrl.isSaving.value
                    ? () {}
                    : () async {
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        var conx = await authService.internetConnectivity();
                        if (conx) {
                          if (!noticiaCtrl.isValidForm()) return;

                          noticiaCtrl.isSaving.value = true;
                          var result = await noticiaCtrl.registroNoticia();

                          if (result == 'OK') {
                            NotificationsService.showSnackbar('Noticia',
                                "La noticia fue enviada.", ContentType.success);
                          } else {
                            NotificationsService.showSnackbar(
                                'Oh! ',
                                "La noticia no fue enviada, $result",
                                ContentType.failure);
                          }
                          noticiaCtrl.isSaving.value = false;
                        } else {
                          NotificationsService.showSnackbar(
                              'Oh! Conexión a intenet',
                              "Debe asegurarse que el dipositivo tenga conexión a internet",
                              ContentType.failure);
                        }
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
    final noticiaCtrl = Get.find<NoticiaController>();

    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
            floating: true,
            delegate: _SliverCustomHeaderDelegate(
                minHeight: 105,
                maxHeight: 221,
                child: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    child: _Titulo()))),
        SliverList(
            delegate: SliverChildListDelegate([
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: _buildDecoration(),
              child: Form(
                key: noticiaCtrl.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      validator: (value) {
                        if (value == null || value.length < 1) {
                          return 'El título es obligatorio';
                        }
                      },
                      onChanged: (value) {
                        noticiaCtrl.titulo.value = value;
                      },
                      decoration: InputDecorations.authInputDecoration(
                          hintText: 'Título de la noticia',
                          labelText: 'Título'),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      maxLines: 10,
                      maxLength: 1500,
                      validator: (value) {
                        if (value == null || value.length < 1) {
                          return 'El cuerpo de la noticia es obligatorio';
                        }
                      },
                      onChanged: (value) {
                        noticiaCtrl.body.value = value;
                      },
                      decoration: InputDecorations.authInputDecoration(
                          hintText: 'Cuerpo de la noticia',
                          labelText: 'Noticia'),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          )
        ]))
      ],
    );
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
        const SizedBox(height: 0),
        SafeArea(
          child: Container(
              color: Colors.white,
              //  margin: EdgeInsets.only(top: 200),
              child: Hero(
                tag: const Text('Noticias'),
                child: BotonGordoNoti(
                  iconL: FontAwesomeIcons.bell,
                  iconR: FontAwesomeIcons.chevronLeft,
                  texto: 'Noticias',
                  color1: const Color.fromARGB(255, 31, 226, 44),
                  color2: const Color.fromARGB(255, 169, 228, 68),
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
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5)
      ]);
}
