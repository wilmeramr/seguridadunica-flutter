import 'dart:async';
import 'dart:convert';

import 'package:flutter_application_1/models/masc_genero_models.dart';
import 'package:flutter_application_1/models/masc_models.dart';
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

  getTopMascota() async {
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

        return null;
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return "Error en la conexion";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexcion';
    }
  }

  getTopMascotaScroll() async {
    if (_page.value < _last_page.value) {
      _page++;
      try {
        print('Busco pagina ${_page}');
        var jsonResponse =
            jsonDecode(await _getJsonData('/api/mascota', _page.value))
                as Map<String, dynamic>;
        if (jsonResponse.containsKey('data')) {
          // final Map<String, dynamic> decodeResp = json.decode(response.body);
          var aut = MascotasResponse.fromMap(jsonResponse);
          data.value = [...data, ...aut.data];
          return null;
          //var itemCount = jsonResponse['totalItems'];
          // print('Number of books about http: $itemCount.');
        } else {
          return "Error en la conexion";
        }
      } on TimeoutException catch (e) {
        return 'Error de conexcion';
      }
    }
  }

  getTopMascotaEspecie() async {
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
        print(dataEspeccies.toString());
        return null;
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return "Error en la conexion";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexcion';
    }
  }

  getTopMascotaGeneros() async {
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
      print(response.body);
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('generos')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = MascotasGenerosResponse.fromMap(jsonResponse);
        datagenero = aut.generos;
        carga.value = 1;

        return null;
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return "Error en la conexion";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexcion';
    }
  }

  Future<bool> checkUrl(String urlv) async {
    final url = Uri(path: urlv);
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    return response.statusCode == 200;
  }
}
