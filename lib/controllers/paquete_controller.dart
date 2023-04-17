import 'dart:convert';
import 'dart:async';

import 'package:Unica/helpers/debouncer.dart';
import 'package:Unica/models/noticias_models.dart';
import 'package:Unica/models/paquete_models.dart';
import 'package:Unica/models/reserva_models.dart';
import 'package:flutter/material.dart';
import 'package:Unica/models/notificacion_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/users_models.dart';
import '../services/services.dart';

class PaqueteController extends GetxController {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;

  final storage = new FlutterSecureStorage();
  var data = <Paquete>[].obs;

  var isLoading = false.obs;
  var isSaving = false.obs;

  var _page = 1.obs;
  var _last_page = 1.obs;

  var enviaA = false.obs;
  var titulo = "".obs;
  var body = "".obs;

  PaqueteController() {
    onInit();
  }

  @override
  void onInit() {
    super.onInit();
    getTopPaquete();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
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

  Future<String?> getTopPaquete() async {
    _page = 1.obs;
    try {
      var body = await _getJsonData('${_baseUrlVersion}/paqueteria');
      var jsonResponse = jsonDecode(body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var reserva = PaqueteResponse.fromMap(jsonResponse);
        data.clear();
        data.addAll(reserva.data);
        _last_page = reserva.lastPage.obs;

        // print(aut);
        return 'Ok';
      } else {
        return "Error de conexión: Intentalo mas tarde";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexión: Intentalo mas tarde';
    } on Exception catch (e) {
      return 'Error de general: Intentalo mas tarde';
    }
  }

  Future<String?> getTopPaqueteScroll() async {
    _page.value += 1;

    if (_page.value <= _last_page.value) {
      try {
        isLoading.value = true;
        var jsonResponse = jsonDecode(await _getJsonData(
                '${_baseUrlVersion}/paqueteria', _page.value))
            as Map<String, dynamic>;
        if (jsonResponse.containsKey('data')) {
          print(jsonResponse);
          var reserva = PaqueteResponse.fromMap(jsonResponse).obs;
          data.value = [...data, ...reserva.value.data];
          update();
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

        return 'Error de conexión: Intentalo mas tarde';
      } on Exception catch (e) {
        _page.value -= 1;
        isLoading.value = false;

        return 'Error de general: Intentalo mas tarde';
      }
    } else {
      return 'Ok';
    }
  }
}
