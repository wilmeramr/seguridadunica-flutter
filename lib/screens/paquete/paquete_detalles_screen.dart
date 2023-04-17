import 'package:Unica/models/paquete_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Unica/models/aut_models.dart';
import 'package:Unica/widgets/widgets.dart';

class PaqueteDetalleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Paquete data = ModalRoute.of(context)!.settings.arguments as Paquete;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Para: ${data.lotName == null ? 'No registrado' : data.lotName}"),
      ),
      body: Stack(
        children: [
          Background(color2: Color(0xff6989F5), color1: Colors.white),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: double.infinity,
                      height: 400,
                      child: data.urlFoto != null
                          ? FadeInImage(
                              placeholder: AssetImage('assets/jar-loading.gif'),
                              image: CachedNetworkImageProvider(
                                data.urlFoto!,
                                errorListener: () => print('hola'),
                              ),
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/no-image.png',
                                    fit: BoxFit.cover);
                              },
                            )
                          : FadeInImage(
                              placeholder: AssetImage('assets/jar-loading.gif'),
                              image: AssetImage('assets/no-image.png'),
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/no-image.png',
                                    fit: BoxFit.cover);
                              },
                            ),
                    ),
                  ),
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Para: ${data.idLote == null ? 'No registrado' : data.lotName}\n'
                      'Empresa envío: ${data.empresaEnvio == null ? 'No registrado' : data.empresaEnvio}\n'
                      'Fecha Recepción: ${data.createdAt?.day.toString().padLeft(2, '0')}-${data.createdAt?.month.toString().padLeft(2, '0')}-${data.createdAt?.year}\n'
                      'observacion: ${data.observacion == null ? '' : data.observacion}\n',
                      textAlign: TextAlign.justify,
                      style: TextStyle(),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
