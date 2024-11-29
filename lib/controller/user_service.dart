// driver_api_service.dart
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserApiService {
  static const String baseUrl = 'http://10.0.2.2:3001/api/auth/admin';

  // Method to get all drivers
static Future<List<dynamic>> getAllusers() async {
  const int maxRetries = 3;
  int retryCount = 0;

  while (retryCount < maxRetries) {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/getAllUsers'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        // Extract and return the driverDetails list
        print('userdetails$data');
        return data['userDetails'];
      } else {
        throw Exception('Failed to load drivers: ${response.statusCode}');
      }
    } catch (e) {
      retryCount++;
      if (retryCount >= maxRetries) {
        throw Exception('Failed to load drivers after $maxRetries attempts: $e');
      }
      await Future.delayed(Duration(seconds: 2)); // Optional: delay before retry
    }
  }

  throw Exception('Unexpected error occurred');
}


  Future<dynamic> blocunblockUser(String driverId, bool isBlocked) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.patch(
        Uri.parse('$baseUrl/blockunblockUser/$driverId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'isBlocked': isBlocked})
      );

       if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return API response
      } else {
        throw Exception('Failed to update block/unblock status');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in blocunblocDriver: $e');
      }
      throw Exception('Failed to update block/unblock status: $e');
    }
  }
  }


  
