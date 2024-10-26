import 'package:flutter/material.dart';
import 'package:rideadmin/LoginPage/login.dart';
import 'package:rideadmin/controller/driver_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverListScreen extends StatefulWidget {
  @override
  _DriverListScreenState createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  List<dynamic> _drivers = [];
  Map<String, dynamic>? _selectedDriver;
  Map<String, dynamic>? vehicleDetails;
  bool _isLoading = true;
  bool _isDetailLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }

  Future<void> _fetchDrivers() async {
    try {
      final drivers = await DriverApiService.getAllDrivers();
      setState(() {
        _drivers = drivers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load drivers: $e')),
      );
    }
  }

  Future<void> _fetchDriverDetails(String driverId) async {
    setState(() {
      _isDetailLoading = true;
      _selectedDriver = null;
    });

    try {
      final response = await DriverApiService.getDriverDetails(driverId);
      final driverDetails = response['driverDetails'];
      vehicleDetails = driverDetails['vehicleDetails'];

      setState(() {
        _selectedDriver = driverDetails;
        _isDetailLoading = false;
      });
      _showDriverDetailDialog();
    } catch (e) {
      setState(() => _isDetailLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load driver details: $e')),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => logout(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Drivers List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _drivers.length,
              itemBuilder: (context, index) {
                final driver = _drivers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_selectedDriver?['profileUrl'] ?? 'https://example.com/default_image.jpg'),
                      radius: 30,
                    ),
                    title: Text(driver['name'] ?? 'No Name Available', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driver['email'] ?? 'No Email Available'),
                        Text(
                          driver['status'] == 'Pending' ? 'Pending Approval' : 'Approved',
                          style: TextStyle(
                            color: driver['status'] == 'Pending' ? Colors.orange : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      final driverId = driver['_id'];
                      if (driverId != null) {
                        _fetchDriverDetails(driverId);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Driver ID is missing.')),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showDriverDetailDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: _isDetailLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                _selectedDriver!['profileUrl'] ??
                                    'https://example.com/default_image.jpg'),
                            radius: 40,
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSectionHeader("Driver Information"),
                      _buildDetailRow(Icons.person, "Name", _selectedDriver!['name']),
                      _buildDetailRow(Icons.email, "Email", _selectedDriver!['email']),
                      _buildDetailRow(Icons.verified_user, "Status",
                          _selectedDriver!['status'] == 'Pending' ? 'Pending Approval' : 'Approved'),
                      Divider(height: 30, color: Colors.grey[300]),

                      _buildSectionHeader("Vehicle Details"),
                      _buildDetailRow(Icons.directions_car, "Vehicle Type", vehicleDetails?['vehicle_type']),
                      _buildDetailRow(Icons.confirmation_number, "RC Number", vehicleDetails?['rc_Number']),
                      const SizedBox(height: 10),

                      _buildSectionHeader("Documents"),
                      _buildImageSection("License Image:", _selectedDriver!['licenseUrl']),
                      _buildImageSection("Permit Image:", vehicleDetails!['permitUrl']),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton("Approve", Colors.green, () {
                            // Handle Approve action
                          }),
                          _buildActionButton("Block", Colors.red, () {
                            // Handle Block action
                          }),
                          _buildActionButton("Unblock", Colors.grey, () {
                            // Handle Unblock action
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          SizedBox(width: 8),
          Text('$title:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 5),
          Expanded(child: Text(value ?? 'n/a')),
        ],
      ),
    );
  }

  Widget _buildImageSection(String title, String? imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showImageDialog(imageUrl),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blueGrey, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 6,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl ?? 'https://example.com/default_image.jpg',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: 14)),
    );
  }

  void _showImageDialog(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image not available')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
              ),
            ),
          ),
        );
      },
    );
  }
}
