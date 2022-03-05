import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../widgets/widgets.dart';

class SliderListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Background(color2: Color(0xff6989F5), color1: Colors.white),
      _MainScroll(),
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
        color: Colors.red,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50))),
        onPressed: () {},
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

class _MainScroll extends StatelessWidget {
  final items = [
    _ListItem(titulo: 'Orange', color: Colors.green),
    _ListItem(titulo: 'Family', color: Colors.blue),
    _ListItem(titulo: 'Subscriptions', color: Color(0xffF7CDD5)),
    _ListItem(titulo: 'Books', color: Color(0xffFCEBAF)),
    _ListItem(titulo: 'Orange', color: Color(0xffF08F66)),
    _ListItem(titulo: 'Family', color: Color(0xffF2A38A)),
    _ListItem(titulo: 'Subscriptions', color: Color(0xffF7CDD5)),
    _ListItem(titulo: 'Books', color: Color(0xffFCEBAF)),
  ];
  List<_ListItem> items2 = [];

  onRefresh() {}

  @override
  Widget build(BuildContext context) {
    final autorizacionesService = Provider.of<AutService>(context);
    final data = autorizacionesService.data;
    items2 = data
        .map((e) => _ListItem(titulo: e.autCode, color: Colors.red))
        .toList();
    return RefreshIndicator(
      edgeOffset: 130,
      onRefresh: () async {
        await autorizacionesService.getTopAut();
      },
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
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
          SliverList(
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
              tag: 'Autorizaciones',
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

class _ListaAutorizacion extends StatelessWidget {
  final items = [
    _ListItem(titulo: 'Orange', color: Color(0xffF08F66)),
    _ListItem(titulo: 'Family', color: Color(0xffF2A38A)),
    _ListItem(titulo: 'Subscriptions', color: Color(0xffF7CDD5)),
    _ListItem(titulo: 'Books', color: Color(0xffFCEBAF)),
    _ListItem(titulo: 'Orange', color: Color(0xffF08F66)),
    _ListItem(titulo: 'Family', color: Color(0xffF2A38A)),
    _ListItem(titulo: 'Subscriptions', color: Color(0xffF7CDD5)),
    _ListItem(titulo: 'Books', color: Color(0xffFCEBAF)),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return items[index];
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  final String titulo;
  final Color color;

  const _ListItem({required this.titulo, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(this.titulo,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
      padding: EdgeInsets.all(30),
      height: 130,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: this.color, borderRadius: BorderRadius.circular(30)),
    );
  }
}
