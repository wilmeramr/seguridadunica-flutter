import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:Unica/extension/timeofday.dart';
import 'package:Unica/models/servicio_tipos_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:time_range_picker/time_range_picker.dart';
import '../models/aut_models.dart';
import '../models/invitacion_models.dart';
import '../models/user.dart';
import '../services/globalkey_service.dart';

class DeliveryController extends GetxController {
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;
  final storage = new FlutterSecureStorage();

  var data = <Datum>[].obs;
  var isLoading = false.obs;
  var _page = 1.obs;
  var _last_page = 1.obs;

  DeliveryController() {
    getTopDeli();
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

  Future<String> getTopDeli() async {
    _page = 1.obs;
    try {
      var jsonResponse =
          jsonDecode(await _getJsonData('${_baseUrlVersion}/autorizacion/3'))
              as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        var aut = AutorizacionResponse.fromJson(jsonResponse);
        data.clear();
        data.addAll(aut.data);
        _last_page = aut.lastPage.obs;
        return 'Ok';
      } else {
        return "Error de conexión: Intentalo mas tarde";
      }
    } on TimeoutException catch (e) {
      return "Error de conexión: Intentalo mas tarde";
    } on Exception catch (e) {
      return "Error de conexión: Intentalo mas tarde";
    }
  }

  Future<String> getTopDeliScroll() async {
    _page.value += 1;

    if (_page.value <= _last_page.value) {
      try {
        isLoading.value = true;
        var jsonResponse = jsonDecode(await _getJsonData(
                '${_baseUrlVersion}/autorizacion/3', _page.value))
            as Map<String, dynamic>;
        if (jsonResponse.containsKey('data')) {
          var aut = AutorizacionResponse.fromJson(jsonResponse);
          data.value = [...data, ...aut.data];
          isLoading.value = false;
          return 'Ok';
        } else {
          _page.value -= 1;
          isLoading.value = false;

          return "Error de conexión: Intentalo mas tarde";
        }
      } on TimeoutException catch (e) {
        _page.value -= 1;
        isLoading.value = false;

        return "Error de conexión: Intentalo mas tarde";
      } on Exception catch (e) {
        _page.value -= 1;
        isLoading.value = false;

        return "Error de conexión: Intentalo mas tarde";
      }
    } else {
      return 'Ok';
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
        'aut_email': email
      };
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/autorizacion');
      final response = await http
          .post(url, headers: requestHeaders, body: json.encode(auhtData))
          .timeout(const Duration(seconds: 10));

      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('link')) {
        var user = await storage.read(key: 'user') ?? '';
        var userDto = User.fromJson(jsonDecode(user) as Map<String, dynamic>);
        var aut = InvitacionResponse.fromJson(jsonResponse);

        return 'Ok';
      } else {
        return "Error de conexión: Intentalo mas tarde";
      }
    } on TimeoutException catch (e) {
      return "Error de conexión: Intentalo mas tarde";
    } on Exception catch (e) {
      return "Error de conexión: Intentalo mas tarde";
    }
  }
}
