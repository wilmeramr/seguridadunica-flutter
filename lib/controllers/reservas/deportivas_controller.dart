import 'dart:convert';
import 'dart:async';

import 'package:Unica/helpers/debouncer.dart';
import 'package:Unica/models/horarios_models.dart';
import 'package:Unica/models/noticias_models.dart';
import 'package:Unica/models/reserva_models.dart';
import 'package:Unica/models/treserva_models.dart';
import 'package:flutter/material.dart';
import 'package:Unica/models/notificacion_models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/user.dart';
import '../../models/users_models.dart';
import '../../services/services.dart';

class DeportivasController extends GetxController {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;

  final storage = new FlutterSecureStorage();
  var data = <Reserva>[].obs;
  var dataHorarios = <Horarios>[].obs;

  late TipoReserva tipoReservaSelected;
  var isLoading = false.obs;
  var isLoadingHorarios = false.obs;

  var isSaving = false.obs;

  var _page = 1.obs;
  var _last_page = 1.obs;

  var enviaA = false.obs;
  var titulo = "".obs;
  var body = "".obs;
  var ubicacionSelected = 1.obs;
  var fechaSelected = DateTime.now().obs;
  DeportivasController() {
    onInit();
  }

  @override
  void onInit() {
    super.onInit();
    // getTopreserva();
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

  Future<String?> getTopTHorarios([int tipo = 2]) async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      print(fechaSelected.value);
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/horarios', {
        'tresr_tipo_horarios': '${tipoReservaSelected.tipoHorarioId}',
        'lugar': '${ubicacionSelected.value}',
        'fecha':
            '${fechaSelected.value.year}${fechaSelected.value.month.toString().padLeft(2, '0')}${fechaSelected.value.day.toString().padLeft(2, '0')}'
      });
      final response = await http
          .get(url, headers: requestHeaders)
          .timeout(const Duration(seconds: 10));

      var body = response.body;
      var jsonResponse = jsonDecode(body) as Map<String, dynamic>;
      print(body);

      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var horario = HorariosResponse.fromMap(jsonResponse);
        dataHorarios.clear();
        dataHorarios.addAll(horario.data);

        // print(aut);
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

  Future<String?> getTopreserva() async {
    _page = 1.obs;
    try {
      var body = await _getJsonData('${_baseUrlVersion}/reservas');
      var jsonResponse = jsonDecode(body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var reserva = ReservaResponse.fromMap(jsonResponse);
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

  Future<String?> getTopreservaScroll() async {
    _page.value += 1;

    if (_page.value <= _last_page.value) {
      try {
        isLoading.value = true;
        var jsonResponse = jsonDecode(
                await _getJsonData('${_baseUrlVersion}/reservas', _page.value))
            as Map<String, dynamic>;
        if (jsonResponse.containsKey('data')) {
          print(jsonResponse);
          var reserva = ReservaResponse.fromMap(jsonResponse).obs;
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

  Future<String> registroNoticia() async {
    try {
      String token = await storage.read(key: 'token') ?? '';

      final Map<String, dynamic> auhtData = {
        'titulo': '$titulo',
        'body': '$body'
      };
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/noticias');
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

  Future<String> PostReserva(Horarios hor) async {
    try {
      var user = await storage.read(key: 'user') ?? '';
      var userDto = User.fromJson(jsonDecode(user) as Map<String, dynamic>);
      print(userDto.loteId);
      print(hor.lote);

      if (hor.noHabilitado == 1 && hor.lote != userDto.loteId) {
        return 'Esta reserva pertenece a otro usuarios';
      }

      if (hor.noHabilitado == 1) {
        return deleteReservaHorarios(hor);
      }

      String token = await storage.read(key: 'token') ?? '';
      final Map<String, dynamic> resrData = {
        'resr_tipo_id': tipoReservaSelected.id,
        'horarioId': hor.id,
        'cant_lugar': ubicacionSelected.value,
        'fecha':
            '${fechaSelected.value.year}${fechaSelected.value.month.toString().padLeft(2, '0')}${fechaSelected.value.day.toString().padLeft(2, '0')}'
      };
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/reservas');
      isSaving.value = true;
      final response = await http
          .post(url, headers: requestHeaders, body: json.encode(resrData))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        dataHorarios.value = dataHorarios.map((element) {
          if (element.id == hor.id) {
            element.noHabilitado = hor.noHabilitado == 1 ? 0 : 1;
            element.lote = userDto.loteId!;
            return element;
          }
          return element;
        }).toList();
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

  Future<String> deleteReservaHorarios(Horarios hor) async {
    try {
      String token = await storage.read(key: 'token') ?? '';
      print('reserva');
      final Map<String, dynamic> resrData = {
        'resr_tipo_id': tipoReservaSelected.id,
        'horarioId': hor.id,
        'cant_lugar': ubicacionSelected.value,
        'fecha':
            '${fechaSelected.value.year}${fechaSelected.value.month.toString().padLeft(2, '0')}${fechaSelected.value.day.toString().padLeft(2, '0')}'
      };
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/reservashorarios');
      isSaving.value = true;
      final response = await http
          .delete(url, headers: requestHeaders, body: json.encode(resrData))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        dataHorarios.value = dataHorarios.map((element) {
          if (element.id == hor.id) {
            element.noHabilitado = hor.noHabilitado == 1 ? 0 : 1;
            element.lote = 1;
            return element;
          }
          return element;
        }).toList();
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

  Future<String> deleteReserva(int id) async {
    try {
      String token = await storage.read(key: 'token') ?? '';
      print('reserva');
      final Map<String, dynamic> resrData = {
        'resr_id': id,
      };
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/reservas');
      isSaving.value = true;
      final response = await http
          .delete(url, headers: requestHeaders, body: json.encode(resrData))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        data.value = data.value.where((element) => element.id != id).toList();
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
