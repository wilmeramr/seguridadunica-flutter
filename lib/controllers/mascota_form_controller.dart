import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:Unica/models/masc_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../services/globalkey_service.dart';

class MascotaFormController extends GetxController {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;
  final storage = new FlutterSecureStorage();
  Rx<Mascota> mascota;
  var isSaving = false.obs;
  File? newPictureFile;

  MascotaFormController(this.mascota) {}
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<String> saveOrCreateMascota() async {
    var result = '';
    if (mascota.value.mascId == null) {
      result = await createMascota(this.mascota.value);
    } else {
      result = await updateMascota(this.mascota.value);
    }

    return result;
  }

  Future<String> updateMascota(Mascota mascota) async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final url = Uri.https(
          _baseUrl, '${_baseUrlVersion}/mascota', {'Authorization': token});
      final response = await http
          .post(url, headers: requestHeaders, body: mascota.toJson())
          .timeout(const Duration(seconds: 10));
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('msg')) {
        return 'update:${jsonResponse.values.first}';
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else if (jsonResponse.containsKey('error')) {
        return 'Error: ' + jsonResponse['error'];
      } else {
        return "Error en la conexion";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexcion';
    } on Exception catch (e) {
      return 'Error de conexcion';
    }
  }

  Future<String> createMascota(Mascota mascota) async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final url = Uri.https(
          _baseUrl, '${_baseUrlVersion}/mascota', {'Authorization': token});
      final response = await http
          .post(url, headers: requestHeaders, body: mascota.toJson())
          .timeout(const Duration(seconds: 10));
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('msg')) {
        return 'create:${jsonResponse.values.last}';
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else if (jsonResponse.containsKey('error')) {
        return 'Error: ' + jsonResponse['error'];
      } else {
        return "Error en la conexion";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexcion';
    } on Exception catch (e) {
      return 'Error de conexcion';
    }
  }

  void updateSelectedMascotaImage(String path) {
    newPictureFile = File.fromUri(Uri(path: path));
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;
    try {
      String token = await storage.read(key: 'token') ?? '';

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/mascota/uploadImg',
          {'Authorization': token});

      final imageUploadRequest = http.MultipartRequest('POST', url);

      final file =
          await http.MultipartFile.fromPath('imagen', newPictureFile!.path)
              .timeout(const Duration(seconds: 10));

      imageUploadRequest.headers.addAll(requestHeaders);
      imageUploadRequest.files.add(file);

      final streamResponse = await imageUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);
      if (resp.statusCode != 200 && resp.statusCode != 201) {
        return null;
      }
      this.newPictureFile = null;
      final decodeData = json.decode(resp.body);
      print(decodeData['link']);
      return decodeData['link'];
    } on TimeoutException catch (e) {
      return 'Error de conexcion';
    } on Exception catch (e) {
      return 'Error de conexcion';
    }
  }
}
