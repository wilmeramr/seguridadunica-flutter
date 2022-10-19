import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/aut_models.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';

class InicioServicioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Background(color2: Color(0xff6989F5), color1: Colors.white),
      _MainScroll(
        onNextPage: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            final servicioService =
                Provider.of<ServicioService>(context, listen: false);
            var result = await servicioService.getTopAutScroll();
            await servicioService.getServicioTipos();

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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50))),
        onPressed: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            Navigator.pushNamed(context, 'invitarServicio');
          } else
            NotificationsService.showSnackbar(
                'Oh!',
                "Debe asegurarse que el dipositivo tenga conexión a internet",
                ContentType.failure);
        },
        child: Text(
          'CREAR UNA VISITA REC',
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
    final servicioService = Provider.of<ServicioService>(context);
    final data = servicioService.data;
    items2 = data.map((e) => _ListItem(servicios: e)).toList();

    return RefreshIndicator(
      edgeOffset: 130,
      onRefresh: () async {
        final authService = Provider.of<AuthService>(context, listen: false);

        var conx = await authService.internetConnectivity();
        if (conx) {
          final servicioService =
              Provider.of<ServicioService>(context, listen: false);
          var result = await servicioService.getTopAut();
          await servicioService.getServicioTipos();

          if (!result.contains('Ok'))
            NotificationsService.showSnackbar(
                'Oh!', "$result", ContentType.failure);
        } else
          NotificationsService.showSnackbar(
              'Oh!',
              "Debe asegurarse que el dipositivo tenga conexión a internet",
              ContentType.failure);
      },
      child: CustomScrollView(
        controller: scrollController,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
          items2.isEmpty && _start > 0
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
                  ...items2,
                  SizedBox(
                    height: 100,
                  )
                ]))
        ],
      ),
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
              tag: const Text('Vistas recurrentes'),
              child: BotonGordo(
                iconL: FontAwesomeIcons.recycle,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Vistas recurrentes',
                color1: Color(0xff317183),
                color2: Color.fromARGB(255, 152, 70, 153),
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
  final Datum servicios;

  const _ListItem({required this.servicios});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'detalleautorizacion',
                arguments: servicios);
          },
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                _NotificacionTitulo(
                  servicios,
                ),
                SizedBox(
                  height: 10,
                ),
                _NotificacionBody(
                  servicios,
                ),
                SizedBox(
                  height: 10,
                ),
                _NotificacionCreado(servicios),
                Divider(),
                _NotificacionStatus(servicios),
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
  final Datum servicios;

  const _NotificacionStatus(this.servicios);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 10,
        decoration: BoxDecoration(
            color: servicios.autActivo == 1 ? Colors.green : Colors.red,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ));
  }
}

class _NotificacionCreado extends StatelessWidget {
  final Datum servicios;

  const _NotificacionCreado(this.servicios);

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
              Text(
                  'Fecha de Creación: ${servicios.createdAt?.day.toString().padLeft(2, '0')}/${servicios.createdAt?.month.toString().padLeft(2, '0')}/${servicios.createdAt?.year.toString().padLeft(4, '0')}')
            ],
          ),
        )
      ],
    ));
  }
}

class _NotificacionBody extends StatelessWidget {
  final Datum servicios;

  const _NotificacionBody(this.servicios);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            FittedBox(
              child: Text(
                  this.servicios.autDesde == null
                      ? "No registrado"
                      : "Desde:  ${this.servicios.autDesde?.day.toString()}-${this.servicios.autDesde?.month.toString()}-${this.servicios.autDesde?.year.toString()}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            FittedBox(
              child: Text(
                  this.servicios.autDesde == null
                      ? "No registrado"
                      : "Hasta:  ${this.servicios.autHasta?.day.toString()}-${this.servicios.autHasta?.month.toString()}-${this.servicios.autHasta?.year.toString()}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ));
  }
}

class _NotificacionTitulo extends StatelessWidget {
  final Datum servicios;

  const _NotificacionTitulo(this.servicios);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          FittedBox(
            child: Text(
                "Para: ${this.servicios.autNombre == null ? "No registrado" : this.servicios.autNombre}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ),
          FittedBox(
            child: Text(
                "De: ${this.servicios.email == null ? "No registrado" : this.servicios.email}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      ),
    );
  }
}
