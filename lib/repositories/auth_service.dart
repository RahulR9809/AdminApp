
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rideadmin/core/style.dart';

class AuthService {
  String baseUrl = "http://$ip:3001/api/auth/admin/login";

  Future<String?> login(String email, String password) async {
    final url = Uri.parse(baseUrl);

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'email': email,  
      'password': password,
    });
    debugPrint('Request body: $body');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Login successful: ${data['message']}');
        return data['accessToken'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Failed to log in: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (error) {
      debugPrint('Error occurred during login: $error');
      throw Exception('An error occurred during login. Please try again.');
    }
  }
}
