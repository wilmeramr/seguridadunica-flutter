import 'dart:convert';

class ReservaResponse {
  ReservaResponse({
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
  List<Reserva> data;
  String? firstPageUrl;
  int? from;
  int lastPage;
  String? lastPageUrl;
  List<Link> links;
  dynamic? nextPageUrl;
  String? path;
  int? perPage;
  dynamic? prevPageUrl;
  int? to;
  int? total;

  factory ReservaResponse.fromJson(String str) =>
      ReservaResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ReservaResponse.fromMap(Map<String, dynamic> json) => ReservaResponse(
        currentPage: json["current_page"],
        data: List<Reserva>.from(json["data"].map((x) => Reserva.fromMap(x))),
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

class Reserva {
  Reserva({
    required this.id,
    required this.fecha,
    required this.description,
    required this.comentarios,
    required this.ubicacion,
    required this.usName,
    required this.usApellido,
    required this.tipo,
    required this.horarios,
    required this.createdAt,
  });

  int id;
  DateTime fecha;
  String description;
  String comentarios;
  String ubicacion;
  String usName;
  String usApellido;
  String tipo;
  String horarios;
  DateTime createdAt;

  factory Reserva.fromJson(String str) => Reserva.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Reserva.fromMap(Map<String, dynamic> json) => Reserva(
        id: json["resr_id"],
        fecha: DateTime.parse(json["resr_fecha"]),
        description: json["tresr_description"],
        comentarios: json["resr_comentarios"],
        ubicacion: json["ubicacion"],
        usName: json["us_name"],
        usApellido: json["us_apellido"],
        tipo: json["resr_tipo"],
        horarios: json["hor_range"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "resr_id": id,
        "resr_fecha": fecha,
        "tresr_description": description,
        "resr_comentarios": comentarios,
        "ubicacion": ubicacion,
        "us_name": usName,
        "us_apellido": usApellido,
        "resr_tipo": tipo,
        "hor_range": horarios,
        "created_at": createdAt.toIso8601String(),
      };
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
