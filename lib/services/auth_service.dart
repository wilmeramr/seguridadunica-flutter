import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Unica/models/version_models.dart';
import 'package:Unica/services/globalkey_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:Unica/models/user.dart';
import 'package:Unica/services/push_notifications_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = GlobalKeyService.urlApiKey;
  final String _baseUrlVersion = GlobalKeyService.urlVersion;

  final storage = new FlutterSecureStorage();

  Future<Map<String, dynamic>?> getVersionApp() async {
    try {
      String token = await storage.read(key: 'token') ?? '';
      String versiones = await storage.read(key: 'version') ?? '';

      if (versiones != '') {
        var ver = jsonDecode(versiones) as Map<String, dynamic>;
        var data = ver['data'];
        if (!DateTime.parse(data['fecha']).isBefore(DateTime.now())) {
          return data;
        } else {
          await storage.delete(key: 'version');
        }
      }
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      final url =
          Uri.https(_baseUrl, '${_baseUrlVersion}/version', {'app': 'unica'});
      final response = await http
          .get(url, headers: requestHeaders)
          .timeout(const Duration(seconds: 10));
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      print(response.body);
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        //  var ver = VersionResponse.fromJson(response.body);

        // print(aut);
        await storage.write(key: 'version', value: response.body);
        return jsonResponse['data'];
      }
    } catch (e) {}
  }

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> auhtData = {
      'email': email,
      'password': password,
      'name': 'flutter',
      'password_confirmation': password,
      'loteid': 1,
      'apellido': 'molina',
    };

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    final url = Uri.https(_baseUrl, '${_baseUrlVersion}/register');

    final response = await http.post(url,
        headers: requestHeaders, body: json.encode(auhtData));

    if (response.statusCode == 201) {
      // final Map<String, dynamic> decodeResp = json.decode(response.body);
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      print(jsonResponse);
      //var itemCount = jsonResponse['totalItems'];
      // print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    //   final Map<String, dynamic> decodeResp = json.decode(resp.body);
    //print(resp);
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> auhtData = {
      'email': email,
      'password': password
    };

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    try {
      print(_baseUrl);
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/login');

      final response = await http
          .post(url, headers: requestHeaders, body: json.encode(auhtData))
          .timeout(const Duration(seconds: 10));
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('token')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        await storage.write(key: 'token', value: jsonResponse['token']);
        await storage.write(
            key: 'user', value: json.encode(jsonResponse['user']));

        await diviceToken(true);

        return null;
        //var itemCount = jsonResponse['totalItems'];
        // print('Number of books about http: $itemCount.');
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return "Error en las credenciaales";
      }
    } on TimeoutException catch (e) {
      return 'Error de conexión: Intentalo mas tarde';
    } on Exception catch (e) {
      print(e);
      return 'Error de general: Intentalo mas tarde';
    }
    //   final Map<String, dynamic> decodeResp = json.decode(resp.body);
    //print(resp);
  }

  Future<Map<String, dynamic>> token(String email) async {
    final Map<String, String> auhtData = {'email': email};

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    try {
      final url = Uri.https(_baseUrl, '${_baseUrlVersion}/token');

      final response = await http
          .post(url, headers: requestHeaders, body: json.encode(auhtData))
          .timeout(const Duration(seconds: 10));

      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.containsKey('message') &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        Map<String, dynamic> resp = {
          'valido': true,
          'r': jsonResponse['message']
        };
        return resp;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        Map<String, dynamic> resp = {
          'valido': false,
          'r': jsonResponse['error'] ??
              'Error de conexión: Intentalo mas tarde. '
        };
        return resp;
      }
    } on TimeoutException catch (e) {
      print(e);
      Map<String, dynamic> resp = {
        'valido': false,
        'r': 'Error de conexión: Intentalo mas tarde'
      };
      return resp;
    } on Exception catch (e) {
      Map<String, dynamic> resp = {
        'valido': false,
        'r': 'Error de general: Intentalo mas tarde'
      };
      print(resp);
      return resp;
    }
    //   final Map<String, dynamic> decodeResp = json.decode(resp.body);
    //print(resp);
  }

  Future<String?> logout() async {
    var result = await diviceToken(false);
    if (result!.contains('Ok')) {
      await storage.delete(key: 'token');
      await storage.delete(key: 'user');
    }
    return result;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<User> readUser() async {
    var user = await storage.read(key: 'user') ?? '';
    var userDto = User.fromJson(jsonDecode(user) as Map<String, dynamic>);
    var userId = userDto.id;
    FirebaseCrashlytics.instance.setUserIdentifier("$userId");

    return userDto;
  }

  Future<String?> diviceToken(bool up) async {
    var user = await storage.read(key: 'user') ?? '';
    String token = await storage.read(key: 'token') ?? '';
    if (user != '' && token != '') {
      var userDto = User.fromJson(jsonDecode(user) as Map<String, dynamic>);
      var deviceToken = PushNotificationService.token;
      print(deviceToken);

      final Map<String, dynamic> auhtData = {
        'token_device': up ? deviceToken : 'x'
      };

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      };
      try {
        final url = Uri.https(_baseUrl, '${_baseUrlVersion}/device');

        final response = await http
            .post(url, headers: requestHeaders, body: json.encode(auhtData))
            .timeout(const Duration(seconds: 10));

        // var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        if (response.statusCode == 201) {
          return 'Ok';
        } else {
          return 'Error de conexión: Intentalo mas tarde';
        }
      } on TimeoutException catch (e) {
        return 'Error de conexión: Intentalo mas tarde';
      } on Exception catch (e) {
        return 'Error de general: Intentalo mas tarde';
      }
    }
  }

  Future<bool> internetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
