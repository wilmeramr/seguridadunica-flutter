import 'dart:convert';

class VersionResponse {
  VersionResponse({
    required this.data,
  });

  List<VersionUnica> data;

  factory VersionResponse.fromJson(String str) =>
      VersionResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VersionResponse.fromMap(Map<String, dynamic> json) => VersionResponse(
        data: List<VersionUnica>.from(
            json["data"].map((x) => VersionUnica.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class VersionUnica {
  VersionUnica({
    required this.app,
    required this.android,
    required this.ios,
  });

  String app;
  int android;
  int ios;

  factory VersionUnica.fromJson(String str) =>
      VersionUnica.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VersionUnica.fromMap(Map<String, dynamic> json) => VersionUnica(
        app: json["app"],
        android: json["android"],
        ios: json["ios"],
      );

  Map<String, dynamic> toMap() => {
        "app": app,
        "android": android,
        "ios": ios,
      };
}
