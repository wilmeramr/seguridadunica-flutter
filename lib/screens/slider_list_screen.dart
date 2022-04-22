import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/aut_models.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class SliderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Background(color2: Color(0xff6989F5), color1: Colors.white),
      _MainScroll(
        onNextPage: () async {
          final autorizacionesService =
              Provider.of<AutService>(context, listen: false);
          await autorizacionesService.getTopAutScroll();
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
        onPressed: () {
          Navigator.pushNamed(context, 'invitar');
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
  int _start = 10;

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
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
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
        await autorizacionesService.getTopAut();
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
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, 'detalleautorizacion',
              arguments: autorizaciones);
        },
        child: Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
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
              ),
              SizedBox(
                width: 20,
              ),
              FaIcon(
                Icons.chevron_right,
                color: Colors.black,
                size: 40,
              ),
            ],
          ),
        ]),
      ),
      padding: EdgeInsets.all(30),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
    );
  }
}
