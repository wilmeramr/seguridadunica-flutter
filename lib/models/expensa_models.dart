import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class ExpenResponse {
  ExpenResponse({
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
  List<Expen> data;
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

  factory ExpenResponse.fromJson(String str) =>
      ExpenResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ExpenResponse.fromMap(Map<String, dynamic> json) => ExpenResponse(
        currentPage: json["current_page"],
        data: List<Expen>.from(json["data"].map((x) => Expen.fromMap(x))),
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

class Expen {
  Expen({
    required this.expenId,
    required this.expenName,
    required this.expenUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  int? expenId;
  String expenName;
  String? expenUrl;
  DateTime createdAt;
  DateTime updatedAt;

  factory Expen.fromJson(String str) => Expen.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Expen.fromMap(Map<String, dynamic> json) => Expen(
        expenId: json["exp_id"],
        expenName: json["exp_name"],
        expenUrl: json["exp_doc_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "exp_id": expenId,
        "exp_name": expenName,
        "exp_doc_url": expenUrl,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
