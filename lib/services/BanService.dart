import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/getUser.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:9090';

  static Future<User> banUser(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/banUser/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);
      return User.fromJson(jsonResponse); // Assuming the response includes the updated user information
    } else {
      throw Exception('Failed to ban user');
    }
  }
  static Future<User> unbanUser(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/UnbanUser/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);
      return User.fromJson(jsonResponse);
      // Assuming the response includes the updated user information
    } else {
      throw Exception('Failed to ban user');
    }
  }
}