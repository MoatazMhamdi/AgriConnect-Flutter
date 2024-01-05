
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin/models/User_Login.dart';

import '../models/otp_model.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:9090';

  Future<User?> login(String name, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        body: {'name': name, 'password': password},
      );

      print('Login response: ${response.body}');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('userId')) {
          // Adjust the following lines based on the actual fields in your response
          final userId = data['userId'];
          final message = data['message'];
          await saveUserIdToLocalStorage(userId);

          // Save the JWT token to local storage
          await saveJwtToLocalStorage(data['jwt']);

          // Create a User object with the available information
          final user = User(userId: userId, name: name, role: 'user', password: '');

          return user;
        } else {
          print('Login failed: User data not found in the response');
          return null;
        }
      } else {
        print('Failed to login: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }
  Future<void> saveUserIdToLocalStorage(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
    } catch (e) {
      throw Exception('Error saving userId to local storage: $e');
    }
  }

  Future<void> saveJwtToLocalStorage(String jwt) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', jwt);
    } catch (e) {
      throw Exception('Error saving JWT to local storage: $e');
    }
  }

  Future<String?> getJwtFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('jwt');
    } catch (e) {
      throw Exception('Error retrieving JWT from local storage: $e');
    }
  }

  Future<void> removeJwtFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt');
    } catch (e) {
      throw Exception('Error removing JWT from local storage: $e');
    }
  }
  Future<void> logout() async {
    try {
      // Clear the saved user details from local storage
      await clearUserDetailsFromLocal();
      // Remove the JWT from local storage
      await removeJwtFromLocalStorage();
      print('Logout successful');
    } catch (e) {
      throw Exception('Error during logout: $e');
    }
  }

  Future<void> clearUserDetailsFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('userId');
      prefs.remove('name');
      print('Cleared userId from local storage');

    } catch (e) {
      throw Exception('Error clearing user details from local storage: $e');
    }
  }
  static Future<OtpModel> forgetPassword(String numTel) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/forgetPassword'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numTel': numTel}),
    );

    if (response.statusCode == 200) {
      return OtpModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
  static Future<void> verifyOtp(String numTel, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/verifyOTP'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numTel': numTel, 'otp': otp}),

    );

    if (response.statusCode == 200) {
      print('OTP verified');
    } else {
      print('Failed to verify OTP. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to verify OTP');    }
  }
  static Future<void> updateUserName(String userId, String newName) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/users/editName/$userId'), // Replace with your API endpoint
        headers: {
          'Content-Type': 'application/json',
          // Add any additional headers as needed
        },
        body: jsonEncode({
          'name': newName,
        }),
      );

      if (response.statusCode == 200) {
        // Successful update, handle as needed
        print('User name updated successfully');
      } else {
        // Handle error, show a snackbar, etc.
        print('Failed to update user name. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating user name: $error');
      // Handle error, show a snackbar, etc.
    }
  }
}