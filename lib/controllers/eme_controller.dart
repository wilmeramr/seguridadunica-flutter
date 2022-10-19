import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../services/globalkey_service.dart';

class EmeController extends GetxController {
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;

  var isLoading = false.obs;

  final storage = const FlutterSecureStorage();
  Future<String> registroEmergencias(int tipo) async {
    try {
      isLoading.value = true;
      String token = await storage.read(key: 'token') ?? '';

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      final url = Uri.https(_baseUrl, '$_baseUrlVersion/eme');
      final response = await http
          .post(url,
              headers: requestHeaders, body: json.encode({'eme_tipo_id': tipo}))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        isLoading.value = false;

        return 'OK';
      } else {
        isLoading.value = false;

        return "Error de conexión: Intentalo mas tarde";
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      return 'Error de conexión: Intentalo mas tarde';
    } on Exception catch (e) {
      isLoading.value = false;
      return 'Error de general: Intentalo mas tarde';
    }
  }
}
