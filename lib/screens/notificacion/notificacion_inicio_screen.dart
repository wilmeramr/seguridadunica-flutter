import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/notificacion_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../models/aut_models.dart';
import '../../models/notificacion_models.dart';
import '../../models/user.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';

class NotificacionInicioScreen extends StatelessWidget {
  // final notificacionCtrl = Get.find<NotificacionController>();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        body: Stack(children: [
      Background(color2: Color(0xff6989F5), color1: Colors.white),
      _MainScroll(
        onNextPage: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            final notificacionCtrl = Get.find<NotificacionController>();

            var result = await notificacionCtrl.getTopAutScroll();
            if (!result!.contains('Ok'))
              NotificationsService.showMyDialogAndroid(
                  context, 'Notificaciones', result);
          } else
            NotificationsService.showMyDialogAndroid(
                context,
                'No se pudo conectar a intenet',
                'Debe asegurarse que el dipositivo tengo conexion a internet');
        },
        onInitNoti: () async {
          final notificacionCtrl = Get.find<NotificacionController>();

          var result = await notificacionCtrl.getTopNoti();
          if (!result!.contains('Ok'))
            NotificationsService.showMyDialogAndroid(
                context, 'Notificaciones', result);
        },
      ),
      Positioned(
          bottom: -10,
          right: 0,
          child: FutureBuilder(
            future: authService.readUser(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              if (snapshot.data!.rol.contains('Adm')) return _BotonNewList();
              return Container();
            },
          ))
    ]));
  }
}

class _BotonNewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ButtonTheme(
      minWidth: size.width * 0.9,
      height: 100,
      child: MaterialButton(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50))),
        onPressed: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            Navigator.pushNamed(context, 'evniarNotificacion');
          } else
            NotificationsService.showMyDialogAndroid(
                context,
                'No se pudo conectar a intenet',
                'Debe asegurarse que el dipositivo tengo conexion a internet');
        },
        child: Text(
          'CREAR UNA NOTIFICACICON',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 3),
        ),
      ),
    );
  }
}

class _MainScroll extends StatefulWidget {
  final Function onNextPage;
  final Function onInitNoti;

  const _MainScroll(
      {Key? key, required this.onNextPage, required this.onInitNoti})
      : super(key: key);
  @override
  State<_MainScroll> createState() => _MainScrollState();
}

class _MainScrollState extends State<_MainScroll> {
  final ScrollController scrollController = ScrollController();
  final notificacionCtrl = Get.find<NotificacionController>();
  Timer? _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    widget.onInitNoti();
    scrollController.addListener(() {
      /*  print(scrollController.position.pixels);
      print(scrollController.position.maxScrollExtent);
      print('lanzar${scrollController.position.maxScrollExtent - 4600}'); */
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print(scrollController.position.pixels);
        //print(scrollController.position.maxScrollExtent);

        widget.onNextPage();
      }
      ;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // notificacionCtrl.data.clear();
    super.dispose();
  }

  List<_ListItem> items2 = [];

  onRefresh() {}

  @override
  Widget build(BuildContext context) {
    final notificacionCtrl = Get.find<NotificacionController>();

    return RefreshIndicator(
      edgeOffset: 130,
      onRefresh: () async {
        final authService = Provider.of<AuthService>(context, listen: false);

        var conx = await authService.internetConnectivity();
        if (conx) {
          final badgeCtrl = Get.find<BadgeController>();
          badgeCtrl.badge.value = 0;
          await notificacionCtrl.getTopNoti();
          var result = await notificacionCtrl.getTopNoti();
          if (!result!.contains('Ok'))
            NotificationsService.showMyDialogAndroid(
                context, 'Notificaciones', result);
        } else
          NotificationsService.showMyDialogAndroid(
              context,
              'No se pudo conectar a intenet',
              'Debe asegurarse que el dipositivo tengo conexion a internet');
      },
      child: Obx(() => CustomScrollView(
            controller: scrollController,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverPersistentHeader(
                  floating: true,
                  delegate: _SliverCustomHeaderDelegate(
                      minHeight: 170,
                      maxHeight: 200,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.white,
                          child: _Titulo()))),
              notificacionCtrl.data.isEmpty && _start > 0
                  ? SliverList(
                      delegate: SliverChildListDelegate([
                      LinearProgressIndicator(
                        color: Colors.green,
                      ),
                      Center(child: Text('Espere por favor')),
                      SizedBox(
                        height: 10,
                      )
                    ]))
                  : SliverList(
                      delegate: SliverChildListDelegate([
                      ...notificacionCtrl.data
                          .map((e) => _ListItem(noti: e))
                          .toList(),
                      SizedBox(
                        height: 100,
                      )
                    ]))
            ],
          )),
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
                texto: 'Notificaciones',
                color1: Color.fromARGB(255, 105, 245, 203),
                color2: Color.fromARGB(255, 129, 95, 232),
                onPress: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  final Notificacion noti;

  const _ListItem({required this.noti});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                _NotificacionTitulo(
                  noti,
                ),
                SizedBox(
                  height: 10,
                ),
                _NotificacionBody(
                  noti,
                ),
                SizedBox(
                  height: 10,
                ),
                _NotificacionStatus(noti),
                Divider(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
    ]);
  }
}

class _NotificacionStatus extends StatelessWidget {
  final Notificacion noti;

  const _NotificacionStatus(this.noti);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RawMaterialButton(
          onPressed: () {},
          //  fillColor: this.noti.notiEnvio == 1 ? Colors.green : Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Icon(
                this.noti.notiEnvio == 1
                    ? FontAwesomeIcons.checkDouble
                    : FontAwesomeIcons.hourglass,
                color: this.noti.notiEnvio == 1 ? Colors.blue : Colors.red,
              ),
              this.noti.notiEnvio == 1
                  ? Text(
                      'Fecha de envio: ${noti.updatedAt.day.toString().padLeft(2, '0')}/${noti.updatedAt.month.toString().padLeft(2, '0')}/${noti.updatedAt.year.toString().padLeft(4, '0')}')
                  : Text('No Enviado')
            ],
          ),
        )
      ],
    ));
  }
}

class _NotificacionBody extends StatelessWidget {
  final Notificacion noti;

  const _NotificacionBody(this.noti);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Text(
          '${noti.notiBody}${noti.notiBody}${noti.notiBody}${noti.notiBody}${noti.notiBody}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.justify,
        ));
  }
}

class _NotificacionTitulo extends StatelessWidget {
  final Notificacion noti;

  const _NotificacionTitulo(this.noti);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Text(this.noti.notiTitulo),
    );
  }
}

class _NotificacionTopBar extends StatelessWidget {
  final Notificacion noti;

  const _NotificacionTopBar(this.noti);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(bottom: 0),
      child: Row(
        children: [Text('${this.noti.notiTitulo}')],
      ),
    );
  }
}
