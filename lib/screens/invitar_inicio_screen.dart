import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class InvitarInicioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final autorizacionesService = Provider.of<AutService>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Background(color1: Color(0xff6989F5), color2: Colors.white),
          Container(
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
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(top: 150),
            child: SingleChildScrollView(
                child: Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(primary: Colors.green)),
              child: _ListaAutorizacion(),
            )),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 0,
          child: Icon(FontAwesomeIcons.plus),
          onPressed: () {
            Navigator.pushNamed(context, 'invitar');
          }),
    );
  }
}

class _ListaAutorizacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          width: 100,
          color: Colors.red,
        );
      },
    );
  }
}
