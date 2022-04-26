import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/aut_models.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';

class InicioAutorizaScreen extends StatelessWidget {
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
            final autorizacionesService =
                Provider.of<AutService>(context, listen: false);
            var result = await autorizacionesService.getTopAutScroll();

            if (!result.contains('Ok'))
              NotificationsService.showMyDialogAndroid(
                  context, 'Autorizacion', result);
          } else
            NotificationsService.showMyDialogAndroid(
                context,
                'No se pudo conectar a intenet',
                'Debe asegurarse que el dipositivo tengo conexion a internet');
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
            Navigator.pushNamed(context, 'autorizaInvita');
          } else
            NotificationsService.showMyDialogAndroid(
                context,
                'No se pudo conectar a intenet',
                'Debe asegurarse que el dipositivo tengo conexion a internet');
        },
        child: Text(
          'CREAR UNA INVITACION',
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
        print('addListener');
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
    final autorizacionesService = Provider.of<AutService>(context);
    final data = autorizacionesService.data;
    items2 = data.map((e) => _ListItem(autorizaciones: e)).toList();

    return RefreshIndicator(
      edgeOffset: 130,
      onRefresh: () async {
        final authService = Provider.of<AuthService>(context, listen: false);

        var conx = await authService.internetConnectivity();
        if (conx) {
          var result = await autorizacionesService.getTopAut();

          if (!result.contains('Ok'))
            NotificationsService.showMyDialogAndroid(
                context, 'Autorizacion', result);
        } else
          NotificationsService.showMyDialogAndroid(
              context,
              'No se pudo conectar a intenet',
              'Debe asegurarse que el dipositivo tengo conexion a internet');
      },
      child: CustomScrollView(
        controller: scrollController,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                  autorizacionesService.isLoading
                      ? CircularProgressIndicator(
                          color: Colors.red,
                        )
                      : Text(""),
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
        SizedBox(height: 0),
        SafeArea(
          child: Container(
            color: Colors.white,
            //  margin: EdgeInsets.only(top: 200),
            child: Hero(
              tag: Text('Autorizaciones'),
              child: BotonGordo(
                iconL: FontAwesomeIcons.idCardAlt,
                iconR: FontAwesomeIcons.chevronLeft,
                texto: 'Autorizaciones',
                color1: Color(0xff6989F5),
                color2: Color(0xff906EF5),
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
  final Datum autorizaciones;

  const _ListItem({required this.autorizaciones});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'detalleautorizacion',
                arguments: autorizaciones);
          },
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                _NotificacionTitulo(
                  autorizaciones,
                ),
                SizedBox(
                  height: 10,
                ),
                _NotificacionBody(
                  autorizaciones,
                ),
                SizedBox(
                  height: 10,
                ),
                _NotificacionStatus(autorizaciones),
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
  final Datum autorizaciones;

  const _NotificacionStatus(this.autorizaciones);

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
                  'Fecha de creación: ${autorizaciones.createdAt?.day.toString().padLeft(2, '0')}/${autorizaciones.createdAt?.month.toString().padLeft(2, '0')}/${autorizaciones.createdAt?.year.toString().padLeft(4, '0')}')
            ],
          ),
        )
      ],
    ));
  }
}

class _NotificacionBody extends StatelessWidget {
  final Datum autorizaciones;

  const _NotificacionBody(this.autorizaciones);

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
                  this.autorizaciones.autDesde == null
                      ? "No registrado"
                      : "Desde:  ${this.autorizaciones.autDesde?.day.toString()}-${this.autorizaciones.autDesde?.month.toString()}-${this.autorizaciones.autDesde?.year.toString()}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            FittedBox(
              child: Text(
                  this.autorizaciones.autDesde == null
                      ? "No registrado"
                      : "Hasta:  ${this.autorizaciones.autHasta?.day.toString()}-${this.autorizaciones.autHasta?.month.toString()}-${this.autorizaciones.autHasta?.year.toString()}",
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
  final Datum autorizaciones;

  const _NotificacionTitulo(this.autorizaciones);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          FittedBox(
            child: Text(
                "Para: ${this.autorizaciones.autNombre == null ? "No registrado" : this.autorizaciones.autNombre}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ),
          FittedBox(
            child: Text(
                "De: ${this.autorizaciones.email == null ? "No registrado" : this.autorizaciones.email}",
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
