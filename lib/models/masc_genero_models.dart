import 'package:meta/meta.dart';
import 'dart:convert';

class MascotasGenerosResponse {
  MascotasGenerosResponse({
    required this.generos,
  });

  List<Genero> generos;

  factory MascotasGenerosResponse.fromJson(String str) =>
      MascotasGenerosResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MascotasGenerosResponse.fromMap(Map<String, dynamic> json) =>
      MascotasGenerosResponse(
        generos:
            List<Genero>.from(json["generos"].map((x) => Genero.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "generos": List<dynamic>.from(generos.map((x) => x.toMap())),
      };
}

class Genero {
  Genero({
    required this.mascGeneId,
    required this.mascGeneName,
    required this.mascGeneActivo,
  });

  int mascGeneId;
  String mascGeneName;
  int mascGeneActivo;

  factory Genero.fromJson(String str) => Genero.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Genero.fromMap(Map<String, dynamic> json) => Genero(
        mascGeneId: json["masc_gene_id"],
        mascGeneName: json["masc_gene_name"],
        mascGeneActivo: json["masc_gene_activo"],
      );

  Map<String, dynamic> toMap() => {
        "masc_gene_id": mascGeneId,
        "masc_gene_name": mascGeneName,
        "masc_gene_activo": mascGeneActivo,
      };
}
