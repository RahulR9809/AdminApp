// // driver_api_service.dart
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserApiService {
//   static const String baseUrl = 'http://10.0.2.2:3001/api/auth/admin';

//   // Method to get all drivers
// static Future<List<dynamic>> getAllusers() async {
//   const int maxRetries = 3;
//   int retryCount = 0;

//   while (retryCount < maxRetries) {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       final response = await http.get(
//         Uri.parse('$baseUrl/getAllUsers'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 201) {
//         final data = json.decode(response.body);
//         // Extract and return the driverDetails list
//         print('userdetails$data');
//         return data['userDetails'];
//       } else {
//         throw Exception('Failed to load drivers: ${response.statusCode}');
//       }
//     } catch (e) {
//       retryCount++;
//       if (retryCount >= maxRetries) {
//         throw Exception('Failed to load drivers after $maxRetries attempts: $e');
//       }
//       await Future.delayed(Duration(seconds: 2)); // Optional: delay before retry
//     }
//   }

//   throw Exception('Unexpected error occurred');
// }


//   Future<dynamic> blocunblockUser(String driverId, bool isBlocked) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//       final response = await http.patch(
//         Uri.parse('$baseUrl/blockunblockUser/$driverId'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({'isBlocked': isBlocked})
//       );

//        if (response.statusCode == 200) {
//         return jsonDecode(response.body); // Return API response
//       } else {
//         throw Exception('Failed to update block/unblock status');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error in blocunblocDriver: $e');
//       }
//       throw Exception('Failed to update block/unblock status: $e');
//     }
//   }
//   }


  


import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rideadmin/model/user_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApiService {
  static const String baseUrl = 'http://10.0.2.2:3001/api/auth/admin';

  // Method to fetch all users
  static Future<List<UserModel>> getAllUsers() async {
    const int maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');

        if (kDebugMode) {
          print('Fetching all users. Attempt: ${retryCount + 1}');
          print('Authorization Token: $token');
        }

        final response = await http.get(
          Uri.parse('$baseUrl/getAllUsers'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }

        if (response.statusCode == 201) {
          final data = json.decode(response.body);
          List<dynamic> usersJson = data['userDetails'];
          if (kDebugMode) {
            print('Parsed user details: $usersJson');
          }
          return usersJson.map((json) => UserModel.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load users: ${response.statusCode}');
        }
      } catch (e) {
        retryCount++;
        if (kDebugMode) {
          print('Error occurred: $e');
        }
        if (retryCount >= maxRetries) {
          throw Exception('Failed to load users after $maxRetries attempts: $e');
        }
        await Future.delayed(const Duration(seconds: 2)); // Retry delay
      }
    }

    throw Exception('Unexpected error occurred');
  }

  // Method to block/unblock a user
  Future<void> blockUnblockUser(String userId, bool isBlocked) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (kDebugMode) {
        print('Updating block/unblock status for user: $userId');
        print('New status: ${isBlocked ? 'Blocked' : 'Unblocked'}');
        print('Authorization Token: $token');
      }

      final response = await http.patch(
        Uri.parse('$baseUrl/blockunblockUser/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'isBlocked': isBlocked}),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to update block/unblock status');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in blockUnblockUser: $e');
      }
      throw Exception('Failed to update block/unblock status: $e');
    }
  }
}
