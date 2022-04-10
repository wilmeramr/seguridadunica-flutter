import 'dart:convert';

class ServicioTiposResponse {
  ServicioTiposResponse({
    required this.data,
  });

  List<ServicioTipos> data;

  factory ServicioTiposResponse.fromJson(String str) =>
      ServicioTiposResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServicioTiposResponse.fromMap(Map<String, dynamic> json) =>
      ServicioTiposResponse(
        data: List<ServicioTipos>.from(
            json["data"].map((x) => ServicioTipos.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class ServicioTipos {
  ServicioTipos({
    required this.stpId,
    required this.stpDescripcion,
  });

  int stpId;
  String stpDescripcion;

  factory ServicioTipos.fromJson(String str) =>
      ServicioTipos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServicioTipos.fromMap(Map<String, dynamic> json) => ServicioTipos(
        stpId: json["stp_id"],
        stpDescripcion: json["stp_descripcion"],
      );

  Map<String, dynamic> toMap() => {
        "stp_id": stpId,
        "stp_descripcion": stpDescripcion,
      };
}
