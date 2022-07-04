import 'dart:convert';

class UsersResponse {
  UsersResponse({
    required this.data,
  });

  List<Users> data;

  factory UsersResponse.fromJson(String str) =>
      UsersResponse.fromMap(json.decode(str));

  factory UsersResponse.fromMap(Map<String, dynamic> json) => UsersResponse(
        data: List<Users>.from(json["data"].map((x) => Users.fromMap(x))),
      );
}

class Users {
  Users(
      {required this.usrId,
      required this.usrName,
      required this.usrApellido,
      required this.usEmail,
      required this.lotName});

  int usrId;
  String usrName;
  String usrApellido;
  String usEmail;
  String lotName;

  factory Users.fromJson(String str) => Users.fromMap(json.decode(str));

  factory Users.fromMap(Map<String, dynamic> json) => Users(
      usrId: json["us_id"],
      usrName: json["us_name"],
      usrApellido: json["us_apellido"],
      usEmail: json["us_email"],
      lotName: json["lot_name"]);
}
