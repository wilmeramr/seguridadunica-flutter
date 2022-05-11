// To parse this JSON data, do
//
//     final autorizacionResponse = autorizacionResponseFromJson(jsonString);

import 'dart:convert';

AutorizacionResponse autorizacionResponseFromJson(String str) =>
    AutorizacionResponse.fromJson(json.decode(str));

String autorizacionResponseToJson(AutorizacionResponse data) =>
    json.encode(data.toJson());

class AutorizacionResponse {
  AutorizacionResponse({
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
  List<Datum> data;
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

  factory AutorizacionResponse.fromJson(Map<String, dynamic> json) =>
      AutorizacionResponse(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    this.id,
    this.autUserId,
    required this.autCode,
    this.autTipo,
    this.autNombre,
    this.autTipoDocumento,
    this.autDocumento,
    this.autTelefono,
    this.autEmail,
    this.autDesde,
    this.autHasta,
    this.autTipoServicio,
    this.autLunes,
    this.autMartes,
    this.autMiercoles,
    this.autJueves,
    this.autViernes,
    this.autSabado,
    this.autDomingo,
    this.autComentario,
    required this.autCantidadInvitado,
    this.autFechaEvento,
    this.autFechaEventoHasta,
    this.autActivo,
    this.createdAt,
    this.updatedAt,
    required this.email,
  });

  int? id;
  int? autUserId;
  String autCode;
  int? autTipo;
  dynamic autNombre;
  dynamic autTipoDocumento;
  dynamic autDocumento;
  dynamic autTelefono;
  dynamic autEmail;
  DateTime? autDesde;
  DateTime? autHasta;
  dynamic autTipoServicio;
  dynamic autLunes;
  dynamic autMartes;
  dynamic autMiercoles;
  dynamic autJueves;
  dynamic autViernes;
  dynamic autSabado;
  dynamic autDomingo;
  dynamic autComentario;
  int? autCantidadInvitado;
  DateTime? autFechaEvento;
  DateTime? autFechaEventoHasta;
  int? autActivo;
  DateTime? createdAt;
  DateTime? updatedAt;
  String email;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        autUserId: json["aut_user_id"],
        autCode: json["aut_code"],
        autTipo: json["aut_tipo"],
        autNombre: json["aut_nombre"],
        autTipoDocumento: json["aut_tipo_documento"],
        autDocumento: json["aut_documento"],
        autTelefono: json["aut_telefono"],
        autEmail: json["aut_email"],
        autDesde: DateTime.parse(json["aut_desde"]),
        autHasta: DateTime.parse(json["aut_hasta"]),
        autTipoServicio: json["aut_tipo_servicio"],
        autLunes: json["aut_lunes"],
        autMartes: json["aut_martes"] == null ? null : json["aut_martes"],
        autMiercoles: json["aut_miercoles"],
        autJueves: json["aut_jueves"],
        autViernes: json["aut_viernes"],
        autSabado: json["aut_sabado"],
        autDomingo: json["aut_domingo"],
        autComentario: json["aut_comentario"],
        autCantidadInvitado: json["aut_cantidad_invitado"],
        autFechaEvento: json["aut_fecha_evento"] == null
            ? null
            : DateTime.parse(json["aut_fecha_evento"]),
        autFechaEventoHasta: json["aut_fecha_evento_hasta"] == null
            ? null
            : DateTime.parse(json["aut_fecha_evento_hasta"]),
        autActivo: json["aut_activo"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "aut_user_id": autUserId,
        "aut_code": autCode,
        "aut_tipo": autTipo,
        "aut_nombre": autNombre,
        "aut_tipo_documento": autTipoDocumento,
        "aut_documento": autDocumento,
        "aut_telefono": autTelefono,
        "aut_email": autEmail,
        "aut_desde":
            "${autDesde?.year.toString().padLeft(4, '0')}-${autDesde?.month.toString().padLeft(2, '0')}-${autDesde?.day.toString().padLeft(2, '0')}",
        "aut_hasta":
            "${autHasta?.year.toString().padLeft(4, '0')}-${autHasta?.month.toString().padLeft(2, '0')}-${autHasta?.day.toString().padLeft(2, '0')}",
        "aut_tipo_servicio": autTipoServicio,
        "aut_lunes": autLunes,
        "aut_martes": autMartes == null ? null : autMartes,
        "aut_miercoles": autMiercoles,
        "aut_jueves": autJueves,
        "aut_viernes": autViernes,
        "aut_sabado": autSabado,
        "aut_domingo": autDomingo,
        "aut_comentario": autComentario,
        "aut_cantidad_invitado": autCantidadInvitado,
        "aut_fecha_evento": autFechaEvento,
        "aut_fecha_evento_hasta": autFechaEventoHasta,
        "aut_activo": autActivo,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "email": email,
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

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] == null ? null : json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "label": label,
        "active": active,
      };
}
