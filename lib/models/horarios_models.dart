import 'dart:convert';

class HorariosResponse {
  HorariosResponse({
    required this.data,
  });

  List<Horarios> data;

  factory HorariosResponse.fromJson(String str) =>
      HorariosResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HorariosResponse.fromMap(Map<String, dynamic> json) =>
      HorariosResponse(
        data: List<Horarios>.from(json["data"].map((x) => Horarios.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Horarios {
  Horarios({
    required this.id,
    required this.range,
    required this.tipo,
    required this.noHabilitado,
    required this.lote,
  });

  int id;
  String range;
  int tipo;
  int noHabilitado;
  int lote;

  factory Horarios.fromJson(String str) => Horarios.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Horarios.fromMap(Map<String, dynamic> json) => Horarios(
        id: json["hor_id"],
        range: json["hor_range"],
        tipo: json["hor_tipo"],
        noHabilitado: json["no_habilitado"],
        lote: json["lote"],
      );

  Map<String, dynamic> toMap() => {
        "hor_id": id,
        "hor_range": range,
        "hor_tipo": tipo,
        "lote": lote,
      };
}
