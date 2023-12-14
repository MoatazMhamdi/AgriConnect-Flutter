import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agriconnect/models/user_model.dart';

Future<bool> registerUser(UserModel user) async {
  final Uri url = Uri.parse('http://127.0.0.1:9090/users/AdminSignup');

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      // Registration successful, return true
      print('User registered successfully');
      return true;
    } else {
      // Registration failed, return false
      print('Failed to register user');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (error) {
    // Handle network or other errors, return false
    print('Error during registration: $error');
    return false;
  }
}