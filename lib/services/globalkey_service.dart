import 'package:flutter/material.dart';

class GlobalKeyService {
  static String urlApiKey = "acceso.seguridadunica.com";
  static String urlVersion = "/api/v1";
  static String versionApp = "1.3.0";

  static int appVersionAndoid = 9;
  static int appVersionIos = 9;
  static String headerVersion = 'Versión: $versionApp + $appVersionAndoid';
}
