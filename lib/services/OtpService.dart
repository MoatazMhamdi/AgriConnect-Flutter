
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/verify_otp.dart';


class AuthService {
  static const String baseUrl = 'http://127.0.0.1:9090';


  static Future<OtpModel> verifyOtp(String numTel, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/verifyOTP'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numTel': numTel, 'otp': otp}),

    );

    if (response.statusCode == 200) {
      print('OTP verified');
      return OtpModel.fromJson(jsonDecode(response.body));

    } else {
      print('Failed to verify OTP. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to verify OTP');    }
  }
}