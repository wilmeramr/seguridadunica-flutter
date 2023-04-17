import 'package:flutter/material.dart';

class GlobalKeyService {
  static String urlApiKey = "acceso.seguridadunica.com";
  static String urlVersion = "/api/v1";
  static String versionApp = "1.4.0";

  static int appVersionAndoid = 10;
  static int appVersionIos = 10;
  static String headerVersion = 'Versión: $versionApp + $appVersionAndoid';
}
