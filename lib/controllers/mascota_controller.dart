import 'dart:async';
import 'dart:convert';

import 'package:Unikey/models/masc_genero_models.dart';
import 'package:Unikey/models/masc_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/masc_esp_models.dart';
import '../models/user.dart';

class MascotaController extends GetxController {
  final String _baseUrl = 'acceso.seguridadunica.com';
  final storage = new FlutterSecureStorage();

  var data = <Mascota>[].obs;
  late List<Especy> dataEspeccies;
  late List<Genero> datagenero;
  var carga = 0.obs;
  var _page = 1.obs;
  var _last_page = 1.obs;
  Rx<Mascota>? mascotaSelected;
  var isLoading = false.obs;

  var galleryOCamare = 0.obs;

  MascotaController() {
    getTopMascotaEspecie();
    getTopMascotaGeneros();
    getTopMascota();
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

  Future<String> getTopMascota() async {
    _page = 1.obs;
    try {
      var jsonResponse = jsonDecode(await _getJsonData('/api/mascota'))
          as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var masc = MascotasResponse.fromMap(jsonResponse);
        data.clear();
        data.addAll(masc.data);
        _last_page = masc.lastPage.obs;

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

  Future<String> getTopMascotaScroll() async {
    _page.value += 1;

    if (_page.value <= _last_page.value) {
      try {
        isLoading.value = true;
        var jsonResponse =
            jsonDecode(await _getJsonData('/api/mascota', _page.value))
                as Map<String, dynamic>;
        if (jsonResponse.containsKey('data')) {
          // final Map<String, dynamic> decodeResp = json.decode(response.body);
          var aut = MascotasResponse.fromMap(jsonResponse);
          data.value = [...data, ...aut.data];
          isLoading.value = false;
          return 'Ok';
          //var itemCount = jsonResponse['totalItems'];
          // print('Number of books about http: $itemCount.');
        } else {
          _page.value -= 1;
          isLoading.value = false;

          return "Error en la conexion";
        }
      } on TimeoutException catch (e) {
        _page.value -= 1;
        isLoading.value = false;

        return 'Error de conexcion';
      } on Exception catch (e) {
        _page.value -= 1;
        isLoading.value = false;

        return 'Error de conexcion';
      }
    } else {
      return 'Ok';
    }
  }

  Future<String> getTopMascotaEspecie() async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      final url = Uri.https(_baseUrl, '/api/mascota/especies');
      final response = await http
          .get(url, headers: requestHeaders)
          .timeout(const Duration(seconds: 10));

      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('especies')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = MascotasEspeciesResponse.fromMap(jsonResponse);
        dataEspeccies = aut.especies;
        return 'Ok';
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return "Error en la conexion";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexcion';
    } on Exception catch (e) {
      return 'Error de conexcion';
    }
  }

  Future<String> getTopMascotaGeneros() async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      final url = Uri.https(_baseUrl, '/api/mascota/generos');
      final response = await http
          .get(url, headers: requestHeaders)
          .timeout(const Duration(seconds: 10));
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('generos')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = MascotasGenerosResponse.fromMap(jsonResponse);
        datagenero = aut.generos;
        carga.value = 1;

        return 'Ok';
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return "Error en la conexion";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexcion';
    } on Exception catch (e) {
      return 'Error de conexcion';
    }
  }

  Future<bool> checkUrl(String urlv) async {
    final url = Uri(path: urlv);
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } on TimeoutException catch (e) {
      return false;
    } on Exception catch (e) {
      return false;
    }
  }
}
