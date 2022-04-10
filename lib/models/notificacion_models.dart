import 'dart:convert';

class NotificacionesResponse {
  NotificacionesResponse({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
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
  List<Notificacion> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link> links;
  dynamic? nextPageUrl;
  String? path;
  int? perPage;
  dynamic? prevPageUrl;
  int? to;
  int? total;

  factory NotificacionesResponse.fromJson(String str) =>
      NotificacionesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificacionesResponse.fromMap(Map<String, dynamic> json) =>
      NotificacionesResponse(
        currentPage: json["current_page"],
        data: List<Notificacion>.from(
            json["data"].map((x) => Notificacion.fromMap(x))),
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

class Notificacion {
  Notificacion({
    required this.id,
    required this.notiUserId,
    required this.notiAutCode,
    required this.notiTitulo,
    required this.notiBody,
    required this.notiTo,
    required this.notiEvent,
    required this.notiPriority,
    required this.notiEnvio,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int notiUserId;
  String notiAutCode;
  String notiTitulo;
  String notiBody;
  String notiTo;
  String notiEvent;
  String notiPriority;
  int notiEnvio;
  DateTime createdAt;
  DateTime updatedAt;

  factory Notificacion.fromJson(String str) =>
      Notificacion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Notificacion.fromMap(Map<String, dynamic> json) => Notificacion(
        id: json["id"],
        notiUserId: json["noti_user_id"],
        notiAutCode: json["noti_aut_code"],
        notiTitulo: json["noti_titulo"],
        notiBody: json["noti_body"],
        notiTo: json["noti_to"],
        notiEvent: json["noti_event"],
        notiPriority: json["noti_priority"],
        notiEnvio: json["noti_envio"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "noti_user_id": notiUserId,
        "noti_aut_code": notiAutCode,
        "noti_titulo": notiTitulo,
        "noti_body": notiBody,
        "noti_to": notiTo,
        "noti_event": notiEvent,
        "noti_priority": notiPriority,
        "noti_envio": notiEnvio,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
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
