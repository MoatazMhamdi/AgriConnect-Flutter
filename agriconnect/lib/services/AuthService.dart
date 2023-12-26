import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin/models/User_Login.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:9090';

  Future<User?> login(String numTel, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        body: {'numTel': numTel, 'password': password},
      );

      print('Login response: ${response.body}');
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('userId')) {
          // Adjust the following lines based on the actual fields in your response
          final userId = data['userId'];
          final message = data['message'];

          // Save the JWT token to local storage
          await saveJwtToLocalStorage(data['jwt']);

          // Create a User object with the available information
          final user = User(userId: userId, numTel: numTel, role: 'user', password: '');

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
      prefs.remove('numTel');
      print('Cleared userId from local storage');

    } catch (e) {
      throw Exception('Error clearing user details from local storage: $e');
    }
  }

}
