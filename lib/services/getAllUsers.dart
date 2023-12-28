import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/getUser.dart';

class AuthSer {
  static const String baseUrl = 'http://127.0.0.1:9090';

  static Future<Users> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/AllUsers'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);

      // Assuming your API returns a single user data
      return Users.fromJson(jsonResponse);
    } else {
      print('Failed to get users. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to get users');
    }
  }
}


