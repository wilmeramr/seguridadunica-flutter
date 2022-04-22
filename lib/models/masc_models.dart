import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class MascotasResponse {
  MascotasResponse({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<Mascota> data;
  String? firstPageUrl;
  int? from;
  int lastPage;
  String? lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory MascotasResponse.fromJson(String str) =>
      MascotasResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MascotasResponse.fromMap(Map<String, dynamic> json) =>
      MascotasResponse(
        currentPage: json["current_page"],
        data: List<Mascota>.from(json["data"].map((x) => Mascota.fromMap(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromMap(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toMap())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Mascota {
  Mascota({
    this.mascId,
    required this.mascUserId,
    required this.mascName,
    required this.mascEspecieId,
    this.mascRaza,
    required this.mascGeneroId,
    required this.mascPeso,
    required this.mascFechaNacimiento,
    required this.mascFechaVacunacion,
    this.mascDescripcion,
    this.mascUrlFoto,
    this.createdAt,
    this.updatedAt,
  });

  int? mascId;
  int mascUserId;
  String mascName;
  int mascEspecieId;
  String? mascRaza;
  int mascGeneroId;
  double mascPeso;
  DateTime mascFechaNacimiento;
  DateTime mascFechaVacunacion;
  String? mascDescripcion;
  String? mascUrlFoto;
  dynamic createdAt;
  dynamic updatedAt;

  factory Mascota.fromJson(String str) => Mascota.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Mascota.fromMap(Map<String, dynamic> json) => Mascota(
        mascId: json["masc_id"],
        mascUserId: json["masc_user_id"],
        mascName: json["masc_name"],
        mascEspecieId: json["masc_especie_id"],
        mascRaza: json["masc_raza"],
        mascGeneroId: json["masc_genero_id"],
        mascPeso: json["masc_peso"].toDouble(),
        mascFechaNacimiento: DateTime.parse(json["masc_fecha_nacimiento"]),
        mascFechaVacunacion: DateTime.parse(json["masc_fecha_vacunacion"]),
        mascDescripcion: json["masc_descripcion"],
        mascUrlFoto: json["masc_url_foto"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "masc_id": mascId,
        "masc_user_id": mascUserId,
        "masc_name": mascName,
        "masc_especie_id": mascEspecieId,
        "masc_raza": mascRaza,
        "masc_genero_id": mascGeneroId,
        "masc_peso": mascPeso,
        "masc_fecha_nacimiento":
            "${mascFechaNacimiento.year.toString().padLeft(4, '0')}-${mascFechaNacimiento.month.toString().padLeft(2, '0')}-${mascFechaNacimiento.day.toString().padLeft(2, '0')}",
        "masc_fecha_vacunacion":
            "${mascFechaVacunacion.year.toString().padLeft(4, '0')}-${mascFechaVacunacion.month.toString().padLeft(2, '0')}-${mascFechaVacunacion.day.toString().padLeft(2, '0')}",
        "masc_descripcion": mascDescripcion,
        "masc_url_foto": mascUrlFoto,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  Rx<Mascota> copy() => Mascota(
          mascId: this.mascId,
          mascUserId: this.mascUserId,
          mascName: this.mascName,
          mascEspecieId: this.mascEspecieId,
          mascRaza: this.mascRaza,
          mascGeneroId: this.mascGeneroId,
          mascPeso: this.mascPeso,
          mascFechaNacimiento: this.mascFechaNacimiento,
          mascFechaVacunacion: this.mascFechaVacunacion,
          mascDescripcion: this.mascDescripcion,
          mascUrlFoto: this.mascUrlFoto)
      .obs;
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(String str) => Link.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Link.fromMap(Map<String, dynamic> json) => Link(
        url: json["url"] == null ? null : json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toMap() => {
        "url": url == null ? null : url,
        "label": label,
        "active": active,
      };
}
