import 'package:flutter/material.dart';
import 'package:Unica/models/aut_models.dart';
import 'package:Unica/widgets/widgets.dart';

class DetalleAutorizacionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Datum data = ModalRoute.of(context)!.settings.arguments as Datum;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Para: ${data.autNombre == null ? 'No registrado' : data.autNombre}"),
      ),
      body: Stack(
        children: [
          Background(color2: Color(0xff6989F5), color1: Colors.white),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                children: [
                  FittedBox(
                    child: Text(
                      'De: ${data.email}\n'
                      'Para: ${data.autNombre == null ? 'No registrado' : data.autNombre}\n'
                      'Documento: ${data.autDocumento == null ? 'No registrado' : data.autDocumento}\n'
                      'Desde: ${data.autDesde?.day.toString().padLeft(2, '0')}-${data.autDesde?.month.toString().padLeft(2, '0')}-${data.autDesde?.year}\n'
                      'Hasta: ${data.autHasta?.day.toString().padLeft(2, '0')}-${data.autHasta?.month.toString().padLeft(2, '0')}-${data.autHasta?.year}\n',
                      textAlign: TextAlign.justify,
                      style: TextStyle(),
                    ),
                  ),
                  data.autTipo == 3
                      ? FittedBox(
                          child: Text(
                            'Vigencia: ${data.autLunes}\n',
                            textAlign: TextAlign.justify,
                            style: TextStyle(),
                          ),
                        )
                      : Text(''),
                  data.autTipo == 2
                      ? FittedBox(
                          child: Text(
                            'Horarios:\n'
                            'Domingos: ${data.autDomingo}\n'
                            'Lunes: ${data.autLunes}\n'
                            'Martes: ${data.autMartes}\n'
                            'Miercoles: ${data.autMiercoles}\n'
                            'Jueves: ${data.autJueves}\n'
                            'Viernes: ${data.autViernes}\n'
                            'Sabados: ${data.autSabado}\n',
                            textAlign: TextAlign.justify,
                            style: TextStyle(),
                          ),
                        )
                      : Text(''),
                  FittedBox(
                    child: data.autTipo == 3
                        ? Text(
                            'Codigo: ${data.autCode}\n',
                            textAlign: TextAlign.justify,
                            style: TextStyle(),
                          )
                        : Text(
                            'Comentarios: ${data.autComentario == null ? 'Sin comentarios' : data.autComentario}\n'
                            'Codigo: ${data.autCode}\n',
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
