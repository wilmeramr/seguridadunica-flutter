import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class DocResponse {
  DocResponse({
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
  List<Doc> data;
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

  factory DocResponse.fromJson(String str) =>
      DocResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocResponse.fromMap(Map<String, dynamic> json) => DocResponse(
        currentPage: json["current_page"],
        data: List<Doc>.from(json["data"].map((x) => Doc.fromMap(x))),
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

class Doc {
  Doc({
    required this.docId,
    required this.docTipoId,
    required this.docCountryId,
    required this.docName,
    required this.docUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  int? docId;
  int docTipoId;
  int docCountryId;
  String docName;
  String? docUrl;
  DateTime createdAt;
  DateTime updatedAt;

  factory Doc.fromJson(String str) => Doc.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Doc.fromMap(Map<String, dynamic> json) => Doc(
        docId: json["doc_id"],
        docTipoId: json["doc_tipo"],
        docCountryId: json["doc_country_id"],
        docName: json["doc_name"],
        docUrl: json["doc_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "doc_id": docId,
        "doc_tipo": docTipoId,
        "doc_country_id": docCountryId,
        "docName": docName,
        "docUrl": docUrl,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  Rx<Doc> copy() => Doc(
        docId: this.docId,
        docTipoId: this.docTipoId,
        docCountryId: this.docCountryId,
        docName: this.docName,
        docUrl: this.docUrl,
        createdAt: this.createdAt,
        updatedAt: this.updatedAt,
      ).obs;
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
