class Users {
  final List<User> users;

  Users({required this.users});

  factory Users.fromJson(List<dynamic> json) {
    List<User> userList = json.map((userData) => User.fromJson(userData)).toList();

    return Users(users: userList);
  }
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? numTel;
  final String? role;
  final bool? isBanned;

  User({this.id, this.name, this.email, this.password, this.numTel, this.role, this.isBanned});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      numTel: json['numTel'],
      role: json['role'],
      isBanned: json['isBanned'] ?? false,

    );
  }
}