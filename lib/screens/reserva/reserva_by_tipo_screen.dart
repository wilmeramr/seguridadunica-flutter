import 'dart:async';

import 'package:Unica/models/noticias_models.dart';
import 'package:Unica/models/reserva_models.dart';
import 'package:Unica/models/treserva_models.dart';
import 'package:Unica/screens/reserva/CustomDialogBox.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../models/user.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';

late int agrs;

class ReservaByTipoScreen extends StatelessWidget {
  // final notificacionCtrl = Get.find<NotificacionController>();

  @override
  Widget build(BuildContext context) {
    agrs = ModalRoute.of(context)!.settings.arguments as int;

    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        body: Stack(children: [
      const Background(color2: Color(0xff6989F5), color1: Colors.white),
      _MainScroll(
        onNextPage: () async {
          /*   final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            final reservaCtrl = Get.find<TReservaController>();

            var result = await reservaCtrl.getTopreservaScroll();
            if (!result!.contains('Ok')) {
              NotificationsService.showSnackbar(
                  'Oh! ', result, ContentType.failure);
            }
          } else {
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión  a internet",
                ContentType.failure);
          } */
        },
        onInitNoti: () async {
          final reservaCtrl = Get.find<TReservaController>();

          var result = await reservaCtrl.getTopTreserva(agrs);
          if (!result!.contains('OK')) {
            NotificationsService.showSnackbar(
                'Oh! ', result, ContentType.failure);
          }
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

              if (snapshot.data!.rol.contains('Admm')) return _BotonNewList();
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50))),
        onPressed: () async {
          Navigator.pushNamed(context, 'tipoReservas');
          /*     final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            Navigator.pushNamed(context, 'enviarReserva');
          } else {
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión a internet",
                ContentType.failure);
          } */
        },
        child: const Text(
          'CREAR UNA RESERVA',
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
  final treservaCtrl = Get.put(TReservaController());
  Timer? _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
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

        // widget.onNextPage();
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
    final treservaCtrl = Get.find<TReservaController>();

    return RefreshIndicator(
      edgeOffset: 130,
      onRefresh: () async {
        final authService = Provider.of<AuthService>(context, listen: false);

        var conx = await authService.internetConnectivity();
        if (conx) {
          var result = await treservaCtrl.getTopTreserva(agrs);
          if (!result!.contains('OK')) {
            NotificationsService.showSnackbar(
                'Oh!', "$result", ContentType.failure);
          }
        } else {
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión a internet",
              ContentType.failure);
        }
      },
      child: Obx(() => CustomScrollView(
            controller: scrollController,
            physics: BouncingScrollPhysics(
                parent: const AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverPersistentHeader(
                  floating: true,
                  delegate: _SliverCustomHeaderDelegate(
                      minHeight: 170,
                      maxHeight: 233,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.white,
                          child: _Titulo()))),
              treservaCtrl.data.isEmpty && _start > 0
                  ? SliverList(
                      delegate: SliverChildListDelegate([
                      const LinearProgressIndicator(
                        color: Colors.green,
                      ),
                      const Center(child: Text('Espere por favor')),
                      const SizedBox(
                        height: 10,
                      )
                    ]))
                  : SliverList(
                      delegate: SliverChildListDelegate([
                      ...treservaCtrl.data
                          .map((e) => _ListItem(treserva: e))
                          .toList(),
                      treservaCtrl.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.red,
                            )
                          : const Text(""),
                      const SizedBox(
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
        const SizedBox(height: 0),
        SafeArea(
          child: Container(
            color: Colors.white,
            //  margin: EdgeInsets.only(top: 200),

            child: Hero(
              tag: const Text('Reservas'),
              child: BotonGordoNoti(
                iconL: FontAwesomeIcons.solidRegistered,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Reservas',
                color1: const Color.fromARGB(255, 45, 199, 207),
                color2: const Color.fromARGB(255, 33, 54, 131),
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
  final TipoReserva treserva;

  const _ListItem({required this.treserva});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                /*    _NotificacionStatus(
                  reserva: reserva,
                  onPressedCancelar: () async {
                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    var conx = await authService.internetConnectivity();
                    if (conx) {
                      final reservaCtrl = Get.find<ReservaController>();

                      var result = await reservaCtrl.deleteReserva(reserva.id);
                      if (!result.contains('OK')) {
                        NotificationsService.showSnackbar(
                            'Oh! ', result, ContentType.failure);
                      }
                    } else {
                      NotificationsService.showSnackbar(
                          'Oh!',
                          "Debe asegurarse que el dipositivo tenga conexión  a internet",
                          ContentType.failure);
                    }
                  },
                ), */
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                /*   _NotificacionTitulo(
                  reserva,
                ), */
                const SizedBox(
                  height: 10,
                ),
                _NotificacionBody(
                  treserva,
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          )),
    ]);
  }
}

class _NotificacionStatus extends StatelessWidget {
  final Reserva reserva;
  final Function onPressedCancelar;

  const _NotificacionStatus(
      {required this.reserva, required this.onPressedCancelar});
  @override
  Widget build(BuildContext context) {
    final reservaCtrl = Get.find<ReservaController>();

    DateTime now = DateTime.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RawMaterialButton(
          onPressed: () {},
          //  fillColor: this.noti.notiEnvio == 1 ? Colors.green : Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              reserva.fecha.isAfter(now.add(const Duration(days: -1)))
                  ? Obx(() => reservaCtrl.isSaving.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => onPressedCancelar(),
                          child: const Text('Cancelar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          )))
                  : const Text(''),
              const SizedBox(
                width: 5,
              ),
              Text(
                  'Fecha de Reservación: ${reserva.fecha.day.toString().padLeft(2, '0')}/${reserva.fecha.month.toString().padLeft(2, '0')}/${reserva.fecha.year.toString().padLeft(4, '0')}')
            ],
          ),
        )
      ],
    );
  }
}

class _NotificacionBody extends StatelessWidget {
  final TipoReserva treserva;

  const _NotificacionBody(this.treserva);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Text(treserva.description));
  }
}

class _NotificacionTitulo extends StatelessWidget {
  final Reserva reserva;

  const _NotificacionTitulo(this.reserva);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 1, left: 30, right: 30),
      child: Text(
        reserva.description + ' - ' + reserva.ubicacion,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _NotificacionTopBar extends StatelessWidget {
  final Noticia noti;

  const _NotificacionTopBar(this.noti);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 0),
      child: Row(
        children: [Text(noti.noticTitulo)],
      ),
    );
  }
}
