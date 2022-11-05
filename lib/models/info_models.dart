import 'dart:convert';

class InfoResponse {
  InfoResponse({
    required this.data,
  });

  List<InfoUtil> data;

  factory InfoResponse.fromJson(String str) =>
      InfoResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InfoResponse.fromMap(Map<String, dynamic> json) => InfoResponse(
        data: List<InfoUtil>.from(json["data"].map((x) => InfoUtil.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class InfoUtil {
  InfoUtil({
    required this.id,
    required this.countryId,
    required this.titulo,
    required this.body,
    required this.updatedAt,
  });

  int id;
  int countryId;
  String titulo;
  String body;
  DateTime updatedAt;

  factory InfoUtil.fromJson(String str) => InfoUtil.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InfoUtil.fromMap(Map<String, dynamic> json) => InfoUtil(
        id: json["info_id"],
        countryId: json["info_country_id"],
        titulo: json["info_titulo"],
        body: json["info_body"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "info_id": id,
        "info_country_id": countryId,
        "info_titulo": titulo,
        "info_body": body,
        "updated_at": updatedAt,
      };
}
