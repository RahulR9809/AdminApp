import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rideadmin/core/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashService {
  final String baseUrl = 'http://$ip:3001/api/trip/admin';

  Future<Map<String, dynamic>> fetchLatestTrips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('auth_token');
      final response = await http.get(
        Uri.parse('$baseUrl/latest-trips'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        if (kDebugMode) {
          print('Latest trips fetched successfully: $data');
        }
        return data;
      } else {
        if (kDebugMode) {
          print(
              'Failed to fetch latest trips. Status code: ${response.statusCode}');
        }
        throw Exception('Failed to load latest trips');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching latest trips: $e');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchMostActiveDrivers() async {
    try {
      if (kDebugMode) {
        print('Fetching most active drivers...');
      }
      final response =
          await http.get(Uri.parse('$baseUrl/most-active-drivers'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        if (kDebugMode) {
          print('Most active drivers fetched successfully: $data');
        }
        var activeDriver = data['data']?[0];
        if (activeDriver != null) {
          String driverName = activeDriver['name'];
          if (kDebugMode) {
            print('Most Active Driver: $driverName');
          }
        }
        return data;
      } else {
        if (kDebugMode) {
          print(
              'Failed to fetch active drivers. Status code: ${response.statusCode}');
        }
        throw Exception('Failed to load active drivers');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching active drivers: $e');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchTotalCompletedTrips() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/total-trips-completed'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        if (kDebugMode) {
          print('Total completed trips fetched successfully: $data');
        }
        return data;
      } else {
        if (kDebugMode) {
          print(
              'Failed to fetch total completed trips. Status code: ${response.statusCode}');
        }
        throw Exception('Failed to load total completed trips');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching total completed trips: $e');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchTripReport() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('http://$ip:3001/api/payment/admin/trip-report/Weekly'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        if (kDebugMode) {
          print('Total completed trips fetched successfully: $data');
        }
        return data;
      } else {
        if (kDebugMode) {
          print(
            'Failed to fetch total completed trips. Status code: ${response.statusCode}');
        }
        throw Exception('Failed to load total completed trips');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching total completed trips: $e');
      }
      rethrow;
    }
  }
}
