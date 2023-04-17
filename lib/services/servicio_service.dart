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
import 'globalkey_service.dart';

class ServicioService with ChangeNotifier {
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;
  final storage = new FlutterSecureStorage();

  List<Datum> data = [];
  List<ServicioTipos> servicioTipos = [];
  var isLoading = false;
  var _last_page = 1;

  int _page = 1;

  ServicioService() {
    this.getServicioTipos();
    this.getTopAut();
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

  Future<String> getTopAut() async {
    try {
      _page = 1;

      var jsonResponse =
          jsonDecode(await _getJsonData('${_baseUrlVersion}/autorizacion/2'))
              as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = AutorizacionResponse.fromJson(jsonResponse);
        data.clear();
        data.addAll(aut.data);
        _last_page = aut.lastPage;
        notifyListeners();

        return 'Ok';
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return 'Error de conexión: Intentalo mas tarde';
      }
    } on TimeoutException catch (e) {
      return 'Error de conexión: Intentalo mas tarde';
    } on Exception catch (e) {
      return 'Error de conexión: Intentalo mas tarde';
    }
  }

  Future<String> getTopAutScroll() async {
    _page += 1;

    if (_page <= _last_page) {
      try {
        isLoading = true;
        var jsonResponse = jsonDecode(
                await _getJsonData('${_baseUrlVersion}/autorizacion/2', _page))
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
          return 'Error de conexión: Intentalo mas tarde';
        }
      } on TimeoutException catch (e) {
        _page -= 1;
        isLoading = false;

        return 'Error de conexión: Intentalo mas tarde';
      } on Exception catch (e) {
        _page -= 1;
        isLoading = false;

        return 'Error de conexión: Intentalo mas tarde';
      }
    } else {
      return "Ok";
    }
  }

  Future<String> postRegistroInvitacion(
      int tipo,
      DateTime desde,
      DateTime hasta,
      List<bool> isActive,
      List<TimeRange> timeRanges,
      ServicioTipos? valueServiciotipos,
      String? comentarios) async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      final Map<String, dynamic> auhtData = {
        'aut_tipo': '$tipo',
        'aut_desde':
            '${desde.year}${desde.month.toString().padLeft(2, '0')}${desde.day.toString().padLeft(2, '0')}',
        'aut_hasta':
            '${hasta.year}${hasta.month.toString().padLeft(2, '0')}${hasta.day.toString().padLeft(2, '0')}',
        'aut_tipo_servicio': valueServiciotipos?.stpId,
        'aut_domingo': isActive[0]
            ? '${timeRanges[0].startTime.to24hours()} - ${timeRanges[0].endTime.to24hours()}'
            : '00:00 - 00:00',
        'aut_lunes': isActive[1]
            ? '${timeRanges[1].startTime.to24hours()} - ${timeRanges[1].endTime.to24hours()}'
            : '00:00 - 00:00',
        'aut_martes': isActive[2]
            ? '${timeRanges[2].startTime.to24hours()} - ${timeRanges[2].endTime.to24hours()}'
            : '00:00 - 00:00',
        'aut_miercoles': isActive[3]
            ? '${timeRanges[3].startTime.to24hours()} - ${timeRanges[3].endTime.to24hours()}'
            : '00:00 - 00:00',
        'aut_jueves': isActive[4]
            ? '${timeRanges[4].startTime.to24hours()} - ${timeRanges[4].endTime.to24hours()}'
            : '00:00 - 00:00',
        'aut_viernes': isActive[5]
            ? '${timeRanges[5].startTime.to24hours()} - ${timeRanges[5].endTime.to24hours()}'
            : '00:00 - 00:00',
        'aut_sabado': isActive[6]
            ? '${timeRanges[6].startTime.to24hours()} - ${timeRanges[6].endTime.to24hours()}'
            : '00:00 - 00:00',
        'aut_comentario': comentarios == null ? null : '$comentarios',
        'Authorization': token
      };
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/autorizacion');
      final response = await http
          .post(url, headers: requestHeaders, body: json.encode(auhtData))
          .timeout(const Duration(seconds: 10));

      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('link')) {
        var user = await storage.read(key: 'user') ?? '';
        var userDto = User.fromJson(jsonDecode(user) as Map<String, dynamic>);
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = InvitacionResponse.fromJson(jsonResponse);
        aut.link;
        // notifyListeners();

        return aut.link;
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return 'Error de conexión: Intentalo mas tarde';
      }
    } on TimeoutException catch (e) {
      return 'Error de conexión: Intentalo mas tarde';
    } on Exception catch (e) {
      return 'Error de conexión: Intentalo mas tarde';
    }
  }

  Future<String> getServicioTipos() async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/servicio/tipos',
          {'Authorization': token});
      final response = await http
          .get(url, headers: requestHeaders)
          .timeout(const Duration(seconds: 10));

      // print(jsonDecode(response.body));
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var servicioTiposResponse =
            ServicioTiposResponse.fromJson(response.body);
        servicioTipos = servicioTiposResponse.data;
        return "Ok";
      } else {
        return 'Error de conexión: Intentalo mas tarde';
      }
    } on TimeoutException catch (e) {
      return 'Error de conexión: Intentalo mas tarde';
    } on Exception catch (e) {
      return 'Error de conexión: Intentalo mas tarde';
    }
  }
}
