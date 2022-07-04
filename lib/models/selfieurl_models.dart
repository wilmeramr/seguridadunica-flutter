import 'dart:convert';

SelfieResponse invitacionResponseFromJson(String str) =>
    SelfieResponse.fromJson(json.decode(str));

String invitacionResponseToJson(SelfieResponse data) =>
    json.encode(data.toJson());

class SelfieResponse {
  SelfieResponse({
    required this.link,
  });

  String link;

  factory SelfieResponse.fromJson(Map<String, dynamic> json) => SelfieResponse(
        link: json["link"],
      );
  factory SelfieResponse.fromMap(Map<String, dynamic> json) => SelfieResponse(
        link: json["link"],
      );
  Map<String, dynamic> toJson() => {
        "link": link,
      };
}
