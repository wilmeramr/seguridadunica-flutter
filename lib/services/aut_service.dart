import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/aut_models.dart';

class AutService with ChangeNotifier {
  final String _baseUrl = '10.0.2.2:8000';
  final storage = new FlutterSecureStorage();

  List<Datum> data = [];

  AutService() {
    this.getTopAut();
  }

  getTopAut() async {
    String token = await storage.read(key: 'token') ?? '';

    final Map<String, dynamic> auhtData = {'page': 1};

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}'
    };
    try {
      final url = Uri.http(_baseUrl, '/api/autorizacion/1', {'page': '1'});

      final response = await http
          .get(url, headers: requestHeaders)
          .timeout(const Duration(seconds: 10));
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse['user']);
      if (jsonResponse.containsKey('data')) {
        // final Map<String, dynamic> decodeResp = json.decode(response.body);
        var aut = AutorizacionResponse.fromJson(jsonResponse);
        data = aut.data;
        print(data);
        notifyListeners();

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
