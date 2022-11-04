import 'dart:convert';

class TipoReservaResponse {
  TipoReservaResponse({
    required this.data,
  });

  List<TipoReserva> data;

  factory TipoReservaResponse.fromJson(String str) =>
      TipoReservaResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TipoReservaResponse.fromMap(Map<String, dynamic> json) =>
      TipoReservaResponse(
        data: List<TipoReserva>.from(
            json["data"].map((x) => TipoReserva.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class TipoReserva {
  TipoReserva({
    required this.id,
    required this.countryId,
    required this.description,
    required this.tipoId,
    required this.tipoHorarioId,
    required this.cantidad,
    required this.email,
    required this.url,
  });

  int id;
  int countryId;
  int tipoId;
  int tipoHorarioId;
  int cantidad;
  String description;
  String? email;
  String? url;

  factory TipoReserva.fromJson(String str) =>
      TipoReserva.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TipoReserva.fromMap(Map<String, dynamic> json) => TipoReserva(
        id: json["tresr_id"],
        countryId: json["tresr_country_id"],
        description: json["tresr_description"],
        tipoId: json["tresr_tipo"],
        tipoHorarioId: json["tresr_tipo_horarios"],
        cantidad: json["tresr_cant_lugares"],
        url: json["tresr_url"],
        email: json["tresr_email"],
      );

  Map<String, dynamic> toMap() => {
        "tresr_id": id,
        "tresr_country_id": countryId,
        "tresr_description": description,
        "tresr_tipo": tipoId,
        "tresr_tipo_horarios": tipoHorarioId,
        "tresr_cant_lugares": cantidad,
        "tresr_url": url,
        "tresr_email": email,
      };
}
