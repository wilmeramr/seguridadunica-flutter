import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../services/globalkey_service.dart';

class EmeController extends GetxController {
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;

  final storage = const FlutterSecureStorage();
  Future<String> registroEmergencias() async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      final url = Uri.https(_baseUrl, '$_baseUrlVersion/eme');
      final response = await http
          .post(url, headers: requestHeaders)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        return 'OK';
      } else {
        return "Error de conexión: Intentalo mas tarde";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexión: Intentalo mas tarde';
    } on Exception catch (e) {
      return 'Error de general: Intentalo mas tarde';
    }
  }
}
