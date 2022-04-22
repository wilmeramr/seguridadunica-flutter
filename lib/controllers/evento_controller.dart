import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/extension/timeofday.dart';
import 'package:flutter_application_1/models/servicio_tipos_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:time_range_picker/time_range_picker.dart';
import '../models/aut_models.dart';
import '../models/invitacion_models.dart';
import '../models/user.dart';

class EventoController extends GetxController {
  final String _baseUrl = 'acceso.seguridadunica.com';
  final storage = new FlutterSecureStorage();

  var data = <Datum>[].obs;
  var _page = 1.obs;
  var _last_page = 1.obs;

  EventoController() {
    getTopEvento();
  }

  _getJsonData(String endpoint, [int page = 1]) async {
    String token = await storage.read(key: 'token') ?? '';

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    final url = Uri.https(_baseUrl, endpoint, {'page': '$page'});
    final response = await http
        .get(url, headers: requestHeaders)
        .timeout(const Duration(seconds: 10));

    return response.body;
  }

  getTopEvento() async {
    _page = 1.obs;
    try {
      var jsonResponse = jsonDecode(await _getJsonData('/api/autorizacion/4'))
          as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = AutorizacionResponse.fromJson(jsonResponse);
        print(aut.data);

        data.clear();
        data.addAll(aut.data);
        _last_page = aut.lastPage.obs;
        return null;
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return "Error en la conexion";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexcion';
    }
  }

  getTopEventoScroll() async {
    if (_page.value < _last_page.value) {
      _page++;
      try {
        var jsonResponse =
            jsonDecode(await _getJsonData('/api/autorizacion/4', _page.value))
                as Map<String, dynamic>;
        if (jsonResponse.containsKey('data')) {
          // final Map<String, dynamic> decodeResp = json.decode(response.body);
          var aut = AutorizacionResponse.fromJson(jsonResponse);
          data.value = [...data, ...aut.data];
          return null;
          //var itemCount = jsonResponse['totalItems'];
          // print('Number of books about http: $itemCount.');
        } else {
          return "Error en la conexion";
        }
      } on TimeoutException catch (e) {
        return 'Error de conexcion';
      }
    }
  }

  Future<String> postRegistroEvento(
    int tipo,
    DateTime desde,
    DateTime hasta,
    String? cantInvitados,
    String autorizoA,
    String? comentarios,
  ) async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      final Map<String, dynamic> auhtData = {
        'aut_tipo': '$tipo',
        'aut_desde':
            '${desde.year}${desde.month.toString().padLeft(2, '0')}${desde.day.toString().padLeft(2, '0')}',
        'aut_hasta':
            '${hasta.year}${hasta.month.toString().padLeft(2, '0')}${hasta.day.toString().padLeft(2, '0')}',
        'aut_cantidad_invitado': cantInvitados,
        'aut_fecha_evento': desde.toString(),
        'aut_fecha_evento_hasta': hasta.toString(),
        'aut_nombre': autorizoA,
        'aut_comentario': comentarios
      };
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      final url = Uri.http(_baseUrl, '/api/autorizacion');
      final response = await http
          .post(url, headers: requestHeaders, body: json.encode(auhtData))
          .timeout(const Duration(seconds: 10));
      print(response);
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('link')) {
        var user = await storage.read(key: 'user') ?? '';
        var userDto = User.fromJson(jsonDecode(user) as Map<String, dynamic>);
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = InvitacionResponse.fromJson(jsonResponse);

        // notifyListeners();

        return 'Ok';
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else if (jsonResponse.containsKey('error')) {
        return 'Error: ' + jsonResponse['error'];
      } else {
        return "Error en la conexion";
      }
    } on TimeoutException catch (e) {
      print(e);
      return 'Error de conexcion';
    }
  }
}
