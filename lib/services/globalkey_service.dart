import 'package:flutter/material.dart';

class GlobalKeyService {
  static String urlApiKey = "acceso.seguridadunica.com";
  static String urlVersion = "/api/v1";
  static String versionApp = "1.2.0";

  static int appVersionAndoid = 8;
  static int appVersionIos = 8;
  static String headerVersion = 'Versión: $versionApp + $appVersionAndoid';
}
