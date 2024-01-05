

  import 'dart:convert';
  import 'package:http/http.dart' as http;

  class EditService {
  static const String baseUrl = 'http://127.0.0.1:9090'; // Replace with your API base URL

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
