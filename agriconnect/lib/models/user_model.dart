class UserModel {
  final String name;
  final String email;
  final String password;
  final String numTel;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.numTel,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      numTel: json['numTel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'numTel': numTel,
    };
  }

  // Define the copyWith method
  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    String? numTel,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      numTel: numTel ?? this.numTel,
    );
  }
}
