import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Unica/extension/timeofday.dart';
import 'package:Unica/models/servicio_tipos_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:time_range_picker/time_range_picker.dart';
import '../models/aut_models.dart';
import '../models/invitacion_models.dart';
import '../models/user.dart';

class DeliveryService with ChangeNotifier {
  final String _baseUrl = 'acceso.seguridaUnica.com';
  final storage = new FlutterSecureStorage();

  List<Datum> data = [];

  var isLoading = false;
  var _page = 1;
  var _last_page = 1;

  DeliveryService() {
    this.getTopDeli();
  }

  _getJsonData(String endpoint, [int page = 1]) async {
    String token = await storage.read(key: 'token') ?? '';

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final url = Uri.https(
        _baseUrl, endpoint, {'page': '$page', 'Authorization': token});
    final response = await http
        .get(url, headers: requestHeaders)
        .timeout(const Duration(seconds: 10));

    return response.body;
  }

  Future<String> getTopDeli() async {
    try {
      _page = 1;

      var jsonResponse = jsonDecode(await _getJsonData('/api/autorizacion/3'))
          as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = AutorizacionResponse.fromJson(jsonResponse);
        print(aut.data);

        data = aut.data;
        _last_page = aut.lastPage;
        notifyListeners();

        return 'Ok';
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return "Error en la conexion: Intentelo mas tarde";
      }
    } on TimeoutException catch (e) {
      return 'Error en la conexion: Intentelo mas tarde';
    } on Exception catch (e) {
      return 'Error en la conexion: Intentelo mas tarde';
    }
  }

  Future<String> getTopDeliScroll() async {
    _page += 1;

    if (_page <= _last_page) {
      try {
        isLoading = true;

        var jsonResponse =
            jsonDecode(await _getJsonData('/api/autorizacion/3', _page))
                as Map<String, dynamic>;
        if (jsonResponse.containsKey('data')) {
          // final Map<String, dynamic> decodeResp = json.decode(response.body);
          var aut = AutorizacionResponse.fromJson(jsonResponse);
          data = [...data, ...aut.data];
          notifyListeners();

          isLoading = false;

          return 'Ok';
          //var itemCount = jsonResponse['totalItems'];
          // print('Number of books about http: $itemCount.');
        } else {
          _page -= 1;
          isLoading = false;
          return "Error en la conexion: Intentelo mas tarde";
        }
      } on TimeoutException catch (e) {
        _page -= 1;
        isLoading = false;

        return 'Error en la conexion: Intentelo mas tarde';
      } on Exception catch (e) {
        _page -= 1;
        isLoading = false;

        return 'Error en la conexion: Intentelo mas tarde';
      }
    } else {
      return "Ok";
    }
  }

  Future<String> postRegistroDelivery(
    int tipo,
    DateTime desde,
    DateTime hasta,
    String? valueVigencia,
    String autorizoA,
    String? email,
  ) async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      final Map<String, dynamic> auhtData = {
        'aut_tipo': '$tipo',
        'aut_desde':
            '${desde.year}${desde.month.toString().padLeft(2, '0')}${desde.day.toString().padLeft(2, '0')}',
        'aut_hasta':
            '${hasta.year}${hasta.month.toString().padLeft(2, '0')}${hasta.day.toString().padLeft(2, '0')}',
        'aut_lunes': valueVigencia,
        'aut_nombre': autorizoA,
        'aut_email': email,
        'Authorization': token
      };
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
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
        var aut = InvitacionResponse.fromJson(jsonResponse);

        // notifyListeners();

        return 'Ok';
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return "Error en la conexion: Intentelo mas tarde";
      }
    } on TimeoutException catch (e) {
      return 'Error en la conexion: Intentelo mas tarde';
    } on Exception catch (e) {
      return 'Error en la conexion: Intentelo mas tarde';
    }
  }
}
