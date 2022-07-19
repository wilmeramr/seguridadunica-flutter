import 'package:Unica/models/selfieurl_models.dart';
import 'package:Unica/models/users_models.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import '../services/services.dart';

class SelfieController extends GetConnect {
  final storage = new FlutterSecureStorage();
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;

  var isLoading = false.obs;

  Future<String> getUrlPropietorio() async {
    String token = await storage.read(key: 'token') ?? '';

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    try {
      isLoading.value = true;
      var response = await get(
              'https://${_baseUrl}${_baseUrlVersion}/selfieurl',
              headers: requestHeaders)
          .timeout(const Duration(seconds: 10));
      isLoading.value = false;

      final selfie = SelfieResponse.fromMap(response.body);
      return selfie.link;
    } on TimeoutException catch (e) {
      isLoading.value = false;
      return 'Error de conexión: Intentalo mas tarde';
    } on Exception catch (e) {
      isLoading.value = false;
      return 'Error de conexión: Intentalo mas tarde';
    }
  }
}
