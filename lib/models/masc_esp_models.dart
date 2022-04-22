import 'package:meta/meta.dart';
import 'dart:convert';

class MascotasEspeciesResponse {
  MascotasEspeciesResponse({
    required this.especies,
  });

  List<Especy> especies;

  factory MascotasEspeciesResponse.fromJson(String str) =>
      MascotasEspeciesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MascotasEspeciesResponse.fromMap(Map<String, dynamic> json) =>
      MascotasEspeciesResponse(
        especies:
            List<Especy>.from(json["especies"].map((x) => Especy.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "especies": List<dynamic>.from(especies.map((x) => x.toMap())),
      };
}

class Especy {
  Especy({
    required this.mascEspId,
    required this.mascEspName,
    required this.mascEspActivo,
  });

  int mascEspId;
  String mascEspName;
  int mascEspActivo;

  factory Especy.fromJson(String str) => Especy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Especy.fromMap(Map<String, dynamic> json) => Especy(
        mascEspId: json["masc_esp_id"],
        mascEspName: json["masc_esp_name"],
        mascEspActivo: json["masc_esp_activo"],
      );

  Map<String, dynamic> toMap() => {
        "masc_esp_id": mascEspId,
        "masc_esp_name": mascEspName,
        "masc_esp_activo": mascEspActivo,
      };
}
