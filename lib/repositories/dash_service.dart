import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rideadmin/core/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashService {
  final String baseUrl = 'http://$Ip:3001/api/trip/admin';  // Replace with your actual API URL

  // Fetch latest trips
 Future <Map<String, dynamic>> fetchLatestTrips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
              final accessToken= prefs.getString('auth_token');
      final response = await http.get(
        Uri.parse('$baseUrl/latest-trips'),
         headers: {
        'Authorization': 'Bearer $accessToken', // Add the Authorization header
        'Content-Type': 'application/json', // Optional: Set content type if necessary
      },
        );
      
      if (response.statusCode == 200||response.statusCode == 201) {
        // Parse the JSON response
        var data = json.decode(response.body);
        print('Latest trips fetched successfully: ${data}');
        return data; // Assuming the trips are in the "trips" key
      } else {
        print('Failed to fetch latest trips. Status code: ${response.statusCode}');
        throw Exception('Failed to load latest trips');
      }
    } catch (e) {
      print('Error fetching latest trips: $e');
      rethrow;
    }
  }

  // Fetch most active drivers
  Future <Map<String, dynamic>> fetchMostActiveDrivers() async {
    try {
      print('Fetching most active drivers...');
      final response = await http.get(Uri.parse('$baseUrl/most-active-drivers'));

      if (response.statusCode == 200||response.statusCode == 201) {
        // Parse the JSON response
        var data = json.decode(response.body);
        print('Most active drivers fetched successfully: ${data}');
 var activeDriver = data['data']?[0]; // Get the first driver in the list
      if (activeDriver != null) {
        String driverName = activeDriver['name']; // Access the 'name' field
        // print('Most Active Driver: $driverName');
      }
        return data; // Assuming the drivers are in the "drivers" key
      } else {
        print('Failed to fetch active drivers. Status code: ${response.statusCode}');
        throw Exception('Failed to load active drivers');
      }
    } catch (e) {
      print('Error fetching active drivers: $e');
      rethrow;
    }
  }

  // Fetch total completed trips
  Future <Map<String, dynamic>> fetchTotalCompletedTrips() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/total-trips-completed'));

      if (response.statusCode == 200||response.statusCode == 201) {
        // Parse the JSON response
        var data = json.decode(response.body);
        print('Total completed trips fetched successfully: ${data}');
        return data; // Assuming the total trips count is in this key
      } else {
        print('Failed to fetch total completed trips. Status code: ${response.statusCode}');
        throw Exception('Failed to load total completed trips');
      }
    } catch (e) {
      print('Error fetching total completed trips: $e');
      rethrow;
    }
  }



Future<Map<String, dynamic>> fetchTripReport() async {
  try {
              final prefs = await SharedPreferences.getInstance();
              final accessToken= prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://$Ip:3001/api/payment/admin/trip-report/Weekly'),
      headers: {
        'Authorization': 'Bearer $accessToken', // Add the Authorization header
        'Content-Type': 'application/json', // Optional: Set content type if necessary
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Parse the JSON response
      var data = json.decode(response.body);
      print('Total completed trips fetched successfully: $data');
      return data; // Assuming the total trips count is in this key
    } else {
      print('Failed to fetch total completed trips. Status code: ${response.statusCode}');
      throw Exception('Failed to load total completed trips');
    }
  } catch (e) {
    print('Error fetching total completed trips: $e');
    rethrow;
  }
}



}
