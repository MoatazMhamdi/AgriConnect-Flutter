import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/ResetPassword.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:9090';

  static Future<ResetPasswordResponse> resetPassword(String numTel, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/resetPassword'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numTel': numTel, 'newPassword': newPassword}),
    );

    if (response.statusCode == 200) {
      return ResetPasswordResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to reset password. Status code: ${response.statusCode}');
    }
  }
}
