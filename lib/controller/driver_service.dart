// driver_api_service.dart
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DriverApiService {
  static const String baseUrl = 'http://10.0.2.2:3001/api/auth/admin';

  // Method to get all drivers
  static Future<List<dynamic>> getAllDrivers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/getAllDrivers'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Extract and return the driverDetails list
        return data['driverDetails'];
      } else {
        throw Exception('Failed to load drivers');
      }
    } catch (e) {
      throw Exception('Failed to load drivers: $e');
    }
  }

  static Future<Map<String, dynamic>> getDriverDetails(String driverId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/viewDriver-Detail/$driverId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final driverDetails = data['driverDetails'];
        if (driverDetails != null) {
          final vehicleDetails = driverDetails['vehicleDetails'];

          if (vehicleDetails != null) {
            return data;
          } else {
            return {};
          }
        } else {
          return {};
        }
      } else {
        throw Exception('Failed to load driver details');
      }
    } catch (e) {
      throw Exception('Failed to load driver details: $e');
    }
  }

  Future<void> acceptDriver(String driverId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.patch(
        Uri.parse('$baseUrl/approveDriver/$driverId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print("Driver details fetched: $data");
        }
      } else {
        throw Exception('Failed to accept driver');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in acceptDriver: $e');
      }
      throw Exception('Failed to accept driver: $e');
    }
  }

  Future<void> blocunblocDriver(String driverId, bool isBlocked) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.patch(
        Uri.parse('$baseUrl/blockUnblockDrivers/$driverId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: jsonEncode({'isBlocked': isBlocked})
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update block status');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in blocunblocDriver: $e');
      }
      throw Exception('Failed to update block status: $e');
    }
  }
}
