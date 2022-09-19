import 'dart:convert';

class NoticiasResponse {
  NoticiasResponse({
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
  List<Noticia> data;
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

  factory NoticiasResponse.fromJson(String str) =>
      NoticiasResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NoticiasResponse.fromMap(Map<String, dynamic> json) =>
      NoticiasResponse(
        currentPage: json["current_page"],
        data: List<Noticia>.from(json["data"].map((x) => Noticia.fromMap(x))),
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

class Noticia {
  Noticia({
    required this.id,
    required this.noticUserId,
    required this.noticTitulo,
    required this.noticBody,
    required this.noticTo,
    required this.noticToUser,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int noticUserId;
  String noticTitulo;
  String noticBody;
  String noticTo;
  int noticToUser;
  DateTime createdAt;
  DateTime updatedAt;

  factory Noticia.fromJson(String str) => Noticia.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Noticia.fromMap(Map<String, dynamic> json) => Noticia(
        id: json["notic_id"],
        noticUserId: json["notic_user_id"],
        noticTitulo: json["notic_titulo"],
        noticBody: json["notic_body"],
        noticTo: json["notic_to"],
        noticToUser: json["notic_to_user"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "noti_user_id": noticUserId,
        "noti_titulo": noticTitulo,
        "noti_body": noticBody,
        "noti_to": noticTo,
        "noti_to_user": noticToUser,
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
