class User {
  final int id;
  final String name;
  final String apellido;
  final String email;
  final String rol;
  final String lote;
  final int? loteId;
  final int? countryId;

  final String country;

  User(this.id, this.name, this.apellido, this.email, this.rol, this.lote,
      this.country, this.loteId, this.countryId);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        apellido = json['apellido'],
        email = json['email'],
        rol = json['rol'],
        lote = json['lote'],
        loteId = json['loteId'],
        country = json['country'],
        countryId = json['countryId'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
}
