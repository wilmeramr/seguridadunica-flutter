import 'package:Unica/models/paquete_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Unica/controllers/controllers.dart';
import 'package:Unica/models/masc_models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class PaqueteCard extends StatelessWidget {
  final Paquete paq;
  final PaqueteController ctrl;

  const PaqueteCard(
      {Key? key, required this.paq, required PaqueteController this.ctrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final paqueteCtrl = Get.put(PaqueteController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () async {
          Navigator.pushNamed(context, 'paqueteDetalle', arguments: paq);
        },
        child: Container(
          margin: EdgeInsets.only(top: 30, bottom: 50),
          width: double.infinity,
          height: 400,
          decoration: _cardBorders(),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              _BackgroundImage(paq, ctrl),
              _ProductDetails(paq),
              // Positioned(top: 0, right: 0, child: _PriceTag()),
              //Positioned(top: 0, left: 0, child: _NotAvailable())
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 7), blurRadius: 10)
          ]);
}

class _NotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'No disponible',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
    );
  }
}

class _PriceTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '10003.59',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final Paquete _paquete;

  _ProductDetails(this._paquete);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 70,
        width: double.infinity,
        decoration: _buildDecoration(),
        child: Column(
          children: [
            Text(
              _paquete.empresaEnvio,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            FittedBox(
              child: Text(
                'Fecha de Recepción: ${_paquete.createdAt.day}/${_paquete.createdAt.month}/${_paquete.createdAt.year}',
                style: TextStyle(
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() => BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}

class _BackgroundImage extends StatelessWidget {
  final Paquete _paquete;
  final PaqueteController ctrl;
  _BackgroundImage(this._paquete, PaqueteController this.ctrl);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: _paquete.urlFoto != null
            ? FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: CachedNetworkImageProvider(
                  _paquete.urlFoto!,
                  errorListener: () => print('hola'),
                ),
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/no-image.png', fit: BoxFit.cover);
                },
              )
            : FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/no-image.png', fit: BoxFit.cover);
                },
              ),
      ),
    );
  }
}
