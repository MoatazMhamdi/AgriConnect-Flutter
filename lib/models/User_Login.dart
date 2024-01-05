class User {
  final String? userId;
  final String name;
  final String? email;
  final String? numTel;
  final String password;
  final String? role;

  User({
    this.userId,
    required this.name,
    this.email,
    this.numTel,
    required this.password,

    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {

    return User(
      userId: json['_id'] ,
      name: json['name'] ?? '',
      email: json['email'] ,
      numTel: json['numTel'] ,
      password: json['password'] ?? '' ,

      role: json['role'] ,

    );
  }
}