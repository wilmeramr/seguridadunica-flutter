class User {
  final int id;
  final String name;
  final String apellido;
  final String email;
  final String rol;
  final String lote;
  final String country;

  User(this.id, this.name, this.apellido, this.email, this.rol, this.lote,
      this.country);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        apellido = json['apellido'],
        email = json['email'],
        rol = json['rol'],
        lote = json['lote'],
        country = json['country'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
}
