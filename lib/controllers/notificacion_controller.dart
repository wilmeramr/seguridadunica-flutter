import 'dart:convert';
import 'dart:async';

import 'package:flutter_application_1/models/notificacion_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class NotificacionController extends GetxController {
  final String _baseUrl = 'acceso.seguridadunica.com';
  final storage = new FlutterSecureStorage();

  var data = <Notificacion>[].obs;
  var _page = 1.obs;

  NotificacionController() {
    getTopNoti();
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

  getTopNoti() async {
    try {
      var body = await _getJsonData('/api/notificacion');
      print(body);
      var jsonResponse = jsonDecode(body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = NotificacionesResponse.fromMap(jsonResponse).obs;
        data = aut.value.data.obs;
        print(aut);
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

  getTopAutScroll() async {
    _page++;
    try {
      var jsonResponse =
          jsonDecode(await _getJsonData('/api/notificacion', _page.value))
              as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        print(jsonResponse);
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = NotificacionesResponse.fromMap(jsonResponse).obs;
        data.value = [...data, ...aut.value.data];
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

  Future<String> postRegistroInvitacion(
      int tipo, DateTime desde, DateTime hasta) async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      final Map<String, dynamic> auhtData = {
        'aut_tipo': '$tipo',
        'aut_desde':
            '${desde.year}${desde.month.toString().padLeft(2, '0')}${desde.day.toString().padLeft(2, '0')}',
        'aut_hasta':
            '${hasta.year}${hasta.month.toString().padLeft(2, '0')}${hasta.day.toString().padLeft(2, '0')}'
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

      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('link')) {
        var user = await storage.read(key: 'user') ?? '';
        var userDto = User.fromJson(jsonDecode(user) as Map<String, dynamic>);
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = NotificacionesResponse.fromMap(jsonResponse);
        //aut.link;
        // notifyListeners();

        return '${userDto.name} ${userDto.apellido} te a inviatdo a ${userDto.country}'
            'para el dia ${desde.day}/${desde.month}/${desde.year}.'
            'completa tus datos en  para poder confirmar.';
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
