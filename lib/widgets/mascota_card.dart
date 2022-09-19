import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Unica/controllers/controllers.dart';
import 'package:Unica/models/masc_models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class MascotaCard extends StatelessWidget {
  final Mascota masc;
  final MascotaController ctrl;

  const MascotaCard(
      {Key? key, required this.masc, required MascotaController this.ctrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mascotaCtrl = Get.put(MascotaController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          var conx = await authService.internetConnectivity();
          if (conx) {
            final mascotaCtrl = Get.find<MascotaController>();
            mascotaCtrl.mascotaSelected = this.masc.copy();
            Navigator.pushNamed(
              context,
              'mascotaEditar',
            );
          } else
            NotificationsService.showMyDialogAndroid(
                context,
                'No se pudo conectar a intenet',
                'Debe asegurarse que el dipositivo tenga conexión  a internet');
        },
        child: Container(
          margin: EdgeInsets.only(top: 30, bottom: 50),
          width: double.infinity,
          height: 400,
          decoration: _cardBorders(),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              _BackgroundImage(masc, ctrl),
              _ProductDetails(masc),
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
  final Mascota _mascota;

  _ProductDetails(this._mascota);

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
              _mascota.mascName,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            FittedBox(
              child: Text(
                'Ult.Vacunación: ${_mascota.mascFechaVacunacion.day}/${_mascota.mascFechaVacunacion.month}/${_mascota.mascFechaVacunacion.year}',
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
  final Mascota _mascota;
  final MascotaController ctrl;
  _BackgroundImage(this._mascota, MascotaController this.ctrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: _mascota.mascUrlFoto != null
            ? FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: CachedNetworkImageProvider(_mascota.mascUrlFoto!),
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
