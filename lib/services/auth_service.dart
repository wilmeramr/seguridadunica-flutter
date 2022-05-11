import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/push_notifications_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'acceso.seguridadunica.com';

  final storage = new FlutterSecureStorage();

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
    final url = Uri.http(_baseUrl, '/api/register');

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
      final url = Uri.https(_baseUrl, '/api/login');

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
      return 'Error de conexcion';
    } on Exception catch (e) {
      return 'Error de conexcion';
    }
    //   final Map<String, dynamic> decodeResp = json.decode(resp.body);
    //print(resp);
  }

  Future<String?> token(String email) async {
    final Map<String, dynamic> auhtData = {'email': email};

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    try {
      final url = Uri.https(_baseUrl, '/api/token');

      final response = await http
          .post(url, headers: requestHeaders, body: json.encode(auhtData))
          .timeout(const Duration(seconds: 10));
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      if (jsonResponse.containsKey('message')) {
        return jsonResponse['message'];
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return jsonResponse['error'];
        ;
      }
    } on TimeoutException catch (e) {
      return 'Error de conexcion: Intentalo mas tarde';
    } on Exception catch (e) {
      return 'Error de conexcion: Intentalo mas tarde';
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
        final url = Uri.https(_baseUrl, '/api/device');

        final response = await http
            .post(url, headers: requestHeaders, body: json.encode(auhtData))
            .timeout(const Duration(seconds: 10));

        // var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        if (response.statusCode == 201) {
          return 'Ok';
        } else {
          return 'Error de conexcion';
        }
      } on TimeoutException catch (e) {
        return 'Error de conexcion';
      } on Exception catch (e) {
        return 'Error de conexcion: Intentalo mas tarde';
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
