import 'dart:convert';

InvitacionResponse invitacionResponseFromJson(String str) =>
    InvitacionResponse.fromJson(json.decode(str));

String invitacionResponseToJson(InvitacionResponse data) =>
    json.encode(data.toJson());

class InvitacionResponse {
  InvitacionResponse({
    required this.link,
  });

  String link;

  factory InvitacionResponse.fromJson(Map<String, dynamic> json) =>
      InvitacionResponse(
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
      };
}
