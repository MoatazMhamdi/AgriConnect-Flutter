class ResetPasswordResponse {
  final String message;
  //final User user; // Assuming you have a User model

  ResetPasswordResponse(this.message);

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      json['message'],
     // User.fromJson(json['user']),
    );
  }
}
