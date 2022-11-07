import 'dart:convert';
import 'dart:async';

import 'package:Unica/helpers/debouncer.dart';
import 'package:Unica/models/info_models.dart';
import 'package:Unica/models/noticias_models.dart';
import 'package:flutter/material.dart';
import 'package:Unica/models/notificacion_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/users_models.dart';
import '../services/services.dart';

class InfoController extends GetxController {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;

  final storage = new FlutterSecureStorage();
  var data = <InfoUtil>[].obs;

  var isLoading = false.obs;
  var isSaving = false.obs;

  var enviaA = false.obs;
  var titulo = "".obs;
  var body = "".obs;

  InfoController() {
    onInit();
  }

  @override
  void onInit() {
    super.onInit();
    getTopInfo();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  _getJsonData(String endpoint, [int page = 1]) async {
    String token = await storage.read(key: 'token') ?? '';

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    final url = Uri.https(_baseUrl, endpoint);
    final response = await http
        .get(url, headers: requestHeaders)
        .timeout(const Duration(seconds: 10));

    return response.body;
  }

  Future<String?> getTopInfo() async {
    try {
      var body = await _getJsonData('${_baseUrlVersion}/info');
      var jsonResponse = jsonDecode(body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var info = InfoResponse.fromMap(jsonResponse);
        data.clear();
        data.addAll(info.data);

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

  Future<String> registroInfo() async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      final Map<String, dynamic> auhtData = {
        'info_titulo': '$titulo',
        'info_body': '$body'
      };
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/info');
      isSaving.value = true;
      final response = await http
          .post(url, headers: requestHeaders, body: json.encode(auhtData))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        titulo.value = '';
        body.value = '';
        formKey.currentState!.reset();
        isSaving.value = false;

        return 'OK';
      } else {
        isSaving.value = false;

        return "Error de conexión: Intentalo mas tarde";
      }
    } on TimeoutException catch (e) {
      isSaving.value = false;

      return 'Error de conexión: Intentalo mas tarde';
    } on Exception catch (e) {
      isSaving.value = false;

      return 'Error de general: Intentalo mas tarde';
    }
  }
}
