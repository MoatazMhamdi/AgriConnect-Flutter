class User {
  final String? id;
  final String? name;
  final String? email;
  final String? numTel;
  final String? role;
  final bool? isBanned;

  User({this.id, this.name, this.email, this.numTel, this.role, this.isBanned});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      numTel: json['numTel'],
      role: json['role'],
      isBanned: json['isBanned'],
    );
  }
}
