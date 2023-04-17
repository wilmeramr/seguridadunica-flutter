import 'dart:convert';

class PaqueteResponse {
  PaqueteResponse({
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
  List<Paquete> data;
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

  factory PaqueteResponse.fromJson(String str) =>
      PaqueteResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaqueteResponse.fromMap(Map<String, dynamic> json) => PaqueteResponse(
        currentPage: json["current_page"],
        data: List<Paquete>.from(json["data"].map((x) => Paquete.fromMap(x))),
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

class Paquete {
  Paquete({
    required this.id,
    required this.idUserC,
    required this.idUserAuth,
    required this.idLote,
    required this.idEmpresa,
    required this.urlFoto,
    required this.lotName,
    this.observacion,
    required this.empresaEnvio,
    required this.createdAt,
  });

  int id;
  int idUserC;
  int idUserAuth;
  int idLote;
  int idEmpresa;
  String urlFoto;
  String? observacion;
  String lotName;
  String empresaEnvio;
  DateTime createdAt;

  factory Paquete.fromJson(String str) => Paquete.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Paquete.fromMap(Map<String, dynamic> json) => Paquete(
        id: json["paq_id"],
        idUserC: json["paq_user_c"],
        idUserAuth: json["paq_user_auth"],
        idLote: json["paq_lote_id"],
        idEmpresa: json["pad_empr_envio"],
        urlFoto: json["paq_foto"],
        observacion: json["pad_observacion"],
        lotName: json["lot_name"],
        empresaEnvio: json["empresa_envio"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "paq_id": id,
        "paq_user_c": idUserC,
        "paq_user_auth": idUserAuth,
        "paq_lote_id": idLote,
        "pad_empr_envio": idEmpresa,
        "paq_foto": urlFoto,
        "pad_observacion": observacion,
        "lot_name": lotName,
        "empresa_envio": empresaEnvio,
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
