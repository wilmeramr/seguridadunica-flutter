import 'dart:convert';
import 'dart:async';

import 'package:Unikey/helpers/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:Unikey/models/notificacion_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/users_models.dart';
import '../services/services.dart';

class NotificacionController extends GetxController {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;

  final storage = new FlutterSecureStorage();
  final debouncer = Debouncer(duration: Duration(microseconds: 500));
  var data = <Notificacion>[].obs;
  var users = <Users>[].obs;
  late Rx<Users> userIdSelected =
      Users(usrId: 0, usrName: '', usrApellido: '', usEmail: '', lotName: '')
          .obs;
  var isLoading = false.obs;
  var isSaving = false.obs;

  var _page = 1.obs;
  var _last_page = 1.obs;

  var badgeNoti = 'Notificaciones'.obs;

  var enviaA = false.obs;
  var titulo = "".obs;
  var body = "".obs;

  NotificacionController() {
    onInit();
  }

  @override
  void onInit() {
    super.onInit();
    initUsers();
    getTopNoti();
  }

  void initUsers() {
    this.userIdSelected.value =
        Users(usrId: 0, usrName: '', usrApellido: '', usEmail: '', lotName: '');
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
    final url = Uri.https(_baseUrl, endpoint, {'page': '$page'});
    final response = await http
        .get(url, headers: requestHeaders)
        .timeout(const Duration(seconds: 10));

    return response.body;
  }

  Future<String?> getTopNoti() async {
    _page = 1.obs;
    try {
      var body = await _getJsonData('${_baseUrlVersion}/notificacion');
      var jsonResponse = jsonDecode(body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = NotificacionesResponse.fromMap(jsonResponse);
        data.clear();
        data.addAll(aut.data);
        _last_page = aut.lastPage.obs;

        // print(aut);
        return 'Ok';
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        return "Error de conexión: Intentalo mas tarde";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexión: Intentalo mas tarde';
    } on Exception catch (e) {
      return 'Error de general: Intentalo mas tarde';
    }
  }

  Future<String?> getTopNotiScroll() async {
    _page.value += 1;

    if (_page.value <= _last_page.value) {
      try {
        isLoading.value = true;
        var jsonResponse = jsonDecode(await _getJsonData(
                '${_baseUrlVersion}/notificacion', _page.value))
            as Map<String, dynamic>;
        if (jsonResponse.containsKey('data')) {
          print(jsonResponse);
          // final Map<String, dynamic> decodeResp = json.decode(response.body);
          var aut = NotificacionesResponse.fromMap(jsonResponse).obs;
          data.value = [...data, ...aut.value.data];
          update();
          isLoading.value = false;
          return 'Ok';
          //var itemCount = jsonResponse['totalItems'];
          // print('Number of books about http: $itemCount.');
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

  Future<String> RegistroNotificacion() async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      final Map<String, dynamic> auhtData = {
        'to': enviaA.isFalse ? 'T' : 'L',
        'to_user': userIdSelected.value.usrId.toString(),
        'titulo': '$titulo',
        'body': '$body'
      };
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/notificacion');
      isSaving.value = true;
      final response = await http
          .post(url, headers: requestHeaders, body: json.encode(auhtData))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        titulo.value = '';
        body.value = '';
        initUsers();
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

  Future<List<Users>> getUsers(String query) async {
    String token = await storage.read(key: 'token') ?? '';

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };

    final Map<String, dynamic> sendData = {
      'query': '$query',
    };

    final url = Uri.https(_baseUrl, '${_baseUrlVersion}/users', sendData);
    final response = await http
        .get(url, headers: requestHeaders)
        .timeout(const Duration(seconds: 10));

    final data = UsersResponse.fromMap(
        jsonDecode(response.body) as Map<String, dynamic>);
    users.value = data.data;
    return data.data;
  }

  void getSguggestionsByQuery(String query) {
    // debouncer.value = '""';
    debouncer.onValue = (value) async {
      final result = await getUsers(value);
      users.value = result;
    };
    final timer = Timer.periodic(const Duration(microseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(microseconds: 301))
        .then((_) => timer.cancel());
  }
}
