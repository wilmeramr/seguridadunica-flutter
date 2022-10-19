import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../models/aut_models.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';

class EventoInicioScreen extends StatelessWidget {
  final eventoCtrl = Get.put(EventoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      const Background(color2: Color(0xff6989F5), color1: Colors.white),
      _MainScroll(
        onNextPage: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            final eventoCtrl = Get.find<EventoController>();

            var result = await eventoCtrl.getTopEventoScroll();

            if (!result.contains('Ok'))
              NotificationsService.showSnackbar(
                  'Oh! ', "${result}", ContentType.failure);
          } else
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión  a internet",
                ContentType.failure);
        },
      ),
      Positioned(bottom: -10, right: 0, child: _BotonNewList())
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
          final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            Navigator.pushNamed(context, 'invitarEventoInicio');
          } else
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión a internet",
                ContentType.failure);
        },
        child: const Text(
          'CREAR UN EVENTO',
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

  const _MainScroll({Key? key, required this.onNextPage}) : super(key: key);
  @override
  State<_MainScroll> createState() => _MainScrollState();
}

class _MainScrollState extends State<_MainScroll> {
  final ScrollController scrollController = ScrollController();
  final eventoCtrl = Get.find<EventoController>();

  Timer? _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
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
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        widget.onNextPage();
      }
      ;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<_ListItem> items2 = [];

  onRefresh() {}

  @override
  Widget build(BuildContext context) {
    // final deliveryService = Provider.of<DeliveryService>(context);
    final eventoCtrl = Get.find<EventoController>();

    return RefreshIndicator(
      edgeOffset: 130,
      onRefresh: () async {
        final authService = Provider.of<AuthService>(context, listen: false);

        var conx = await authService.internetConnectivity();
        if (conx) {
          var result = await eventoCtrl.getTopEvento();

          if (!result.contains('Ok'))
            NotificationsService.showSnackbar(
                'Oh!', "$result", ContentType.failure);
        } else
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión a internet",
              ContentType.failure);
      },
      child: Obx(() => CustomScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
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
              eventoCtrl.data.isEmpty && _start > 0
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
                      ...eventoCtrl.data
                          .map((e) => _ListItem(delivery: e))
                          .toList(),
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
              tag: const Text('Eventos'),
              child: BotonGordo(
                iconL: FontAwesomeIcons.calendarAlt,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Eventos',
                color1: const Color.fromARGB(255, 45, 56, 207),
                color2: const Color.fromARGB(255, 39, 142, 108),
                onPress: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  final Datum delivery;

  const _ListItem({required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'detalleautorizacion',
                arguments: delivery);
          },
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                _NotificacionBody(delivery),
                const SizedBox(
                  height: 0,
                ),
                _NotificacionVigencia(delivery),
                _NotificacionCreado(delivery),
                const Divider(),
                _NotificacionStatus(delivery),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          )),
    ]);
  }
}

class _NotificacionStatus extends StatelessWidget {
  final Datum delivery;

  const _NotificacionStatus(this.delivery);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 10,
        decoration: BoxDecoration(
            color: this.delivery.autActivo == 1 ? Colors.green : Colors.red,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ));
  }
}

class _NotificacionBody extends StatelessWidget {
  final Datum delivery;

  const _NotificacionBody(this.delivery);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Text(
          'Nombre  del Evento: ${delivery.autNombre} ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.justify,
        ));
  }
}

class _NotificacionVigencia extends StatelessWidget {
  final Datum delivery;

  const _NotificacionVigencia(this.delivery);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Text(
          'Fecha del Evento:\n'
          'Desde: ${delivery.autFechaEvento?.day.toString().padLeft(2, '0')}-${delivery.autFechaEvento?.month.toString().padLeft(2, '0')}-${delivery.autFechaEvento?.year} ${delivery.autFechaEvento?.hour.toString().padLeft(2, '0')}:${delivery.autFechaEvento?.minute.toString().padLeft(2, '0')}\n'
          'Hasta: ${delivery.autFechaEventoHasta?.day.toString().padLeft(2, '0')}-${delivery.autFechaEventoHasta?.month.toString().padLeft(2, '0')}-${delivery.autFechaEventoHasta?.year}  ${delivery.autFechaEventoHasta?.hour.toString().padLeft(2, '0')}:${delivery.autFechaEventoHasta?.minute.toString().padLeft(2, '0')}\n'
          'Cantidad de Invitados: ${delivery.autCantidadInvitado}\n',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ));
  }
}

class _NotificacionCreado extends StatelessWidget {
  final Datum delivery;

  const _NotificacionCreado(this.delivery);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Text(
          'Creado por: ${delivery.email}\n'
          'Fecha de Creacion: ${delivery.autDesde?.day.toString().padLeft(2, '0')}-${delivery.autDesde?.month.toString().padLeft(2, '0')}-${delivery.autDesde?.year}\n',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.start,
        ));
  }
}
