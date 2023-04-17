import 'dart:async';
import 'dart:convert';

import 'package:Unica/models/doc_model.dart';
import 'package:Unica/models/masc_genero_models.dart';
import 'package:Unica/models/masc_models.dart';
import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/masc_esp_models.dart';
import '../models/user.dart';
import '../services/globalkey_service.dart';

class DocumentController extends GetxController {
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;
  final storage = new FlutterSecureStorage();

  var data = <Doc>[].obs;
  var carga = 0.obs;
  var _page = 1.obs;
  var _last_page = 1.obs;
  var isLoading = false.obs;
  var isLoadingPDF = false.obs;
  late Rx<PDFDocument> document;
  var galleryOCamare = 0.obs;

  DocumentController() {
    getTopDoc();
  }

  _getJsonData(String endpoint, [int page = 1]) async {
    String token = await storage.read(key: 'token') ?? '';

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final url = Uri.https(_baseUrl, endpoint,
        {'page': '$page', 'doc_tipo': '1', 'Authorization': token});
    final response = await http
        .get(url, headers: requestHeaders)
        .timeout(const Duration(seconds: 10));

    return response.body;
  }

  Future<String> getTopDoc() async {
    _page = 1.obs;
    try {
      var jsonResponse =
          jsonDecode(await _getJsonData('${_baseUrlVersion}/doc'))
              as Map<String, dynamic>;
      print(jsonResponse);

      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var doc = DocResponse.fromMap(jsonResponse);
        data.clear();
        data.addAll(doc.data);
        _last_page = doc.lastPage.obs;

        return 'Ok';
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return "Error de conexión: Intentalo mas tarde";
      }
    } on TimeoutException catch (e) {
      return "Error de conexión: Intentalo mas tarde";
    } on Exception catch (e) {
      print(e);
      return "Error de conexión: Intentalo mas tarde";
    }
  }

  Future<String> getTopDocScroll() async {
    _page.value += 1;

    if (_page.value <= _last_page.value) {
      try {
        isLoading.value = true;
        var jsonResponse = jsonDecode(
                await _getJsonData('${_baseUrlVersion}/doc', _page.value))
            as Map<String, dynamic>;
        if (jsonResponse.containsKey('data')) {
          var doc = DocResponse.fromMap(jsonResponse);
          data.value = [...data, ...doc.data];
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

  Future<void> loadPDF(String url) async {
    var result = await PDFDocument.fromURL(url);

    document = result.obs;
  }
}
