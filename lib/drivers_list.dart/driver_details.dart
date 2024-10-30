import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/controller/driver_service.dart';
import 'package:rideadmin/drivers_list.dart/bloc/driver_bloc.dart';

class DriverDetailsPage extends StatelessWidget {
  final Map<String, dynamic> driverDetails;
  final Map<String, dynamic>? vehicleDetails;

  const DriverDetailsPage({
    Key? key,
    required this.driverDetails,
    this.vehicleDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriverBloc, DriverState>(
      listener: (context, state) {
        if (state is AcceptDriver) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Driver Accepted')),
          );
        } else if (state is BlockUnBlocDriver) {
          CircularProgressIndicator();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.read<DriverBloc>().add(FetchDrivers());
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: const Text(
            'Driver Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.teal[800],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Driver Avatar Section
              Center(
                child: CircleAvatar(
                  radius: 52,
                  backgroundImage: driverDetails['profileUrl'] != null
                      ? NetworkImage(driverDetails['profileUrl'] ?? '')
                      : null,
                  backgroundColor: Colors.teal[200],
                  child: driverDetails['profileUrl'] == null
                      ? const Icon(Icons.person, size: 52, color: Colors.white70)
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              
              // Driver Information Section
              _buildSectionHeader("Driver Information"),
              _buildDetailRow(Icons.person, "Name", driverDetails['name'] ?? 'No name provided'),
              _buildDetailRow(Icons.email, "Email", driverDetails['email'] ?? 'No email provided'),
              _buildDetailRow(
                Icons.verified_user,
                "Status",
                driverDetails['isAccepted'] == false
                    ? 'Pending Approval'
                    : 'Approved',
              ),
              const Divider(height: 30, thickness: 1.5, color: Colors.grey),

              // Vehicle Details Section
              _buildSectionHeader("Vehicle Details"),
              _buildDetailRow(Icons.directions_car, "Vehicle Type", vehicleDetails?['vehicle_type'] ?? 'No vehicle type'),
              _buildDetailRow(Icons.confirmation_number, "RC Number", vehicleDetails?['rc_Number'] ?? 'No RC number'),
              const SizedBox(height: 16),

              // Documents Section
              _buildSectionHeader("Documents"),
              _buildImageSection(context, "License Image:", driverDetails['licenseUrl']),
              _buildImageSection(context, "Permit Image:", vehicleDetails?['permitUrl']),
              const SizedBox(height: 30),

              // Action Buttons Section
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.teal[400]),
          const SizedBox(width: 12),
          Text('$title:', style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, String title, String? imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.teal)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showImageDialog(context, imageUrl),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.teal[200]!, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl == null || imageUrl.isEmpty
                  ? const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 100,
                    )
                  : Image.network(
                      imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 100,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    bool isAccepted = driverDetails['isAccepted'] ?? false;
    bool isBlocked = driverDetails['isBlocked'] ?? false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (!isAccepted)
          _buildActionButton(context, 'Accept', Colors.green, () {
            _showConfirmationDialog(context, 'Accept', () {
              context.read<DriverBloc>().add(AcceptDriver(driverId: driverDetails['id'] ?? 'unknown'));
            });
          }),
        if (isAccepted) ...[
          _buildActionButton(context, 'Block', Colors.red, isBlocked ? null : () {
            _showConfirmationDialog(context, 'Block', () {
              context.read<DriverBloc>().add(BlockUnBlocDriver(driverId: driverDetails['id'] ?? 'unknown', isBlocked: true));
            });
          }),
          _buildActionButton(context, 'Unblock', Colors.blue, !isBlocked ? null : () {
            _showConfirmationDialog(context, 'Unblock', () {
              context.read<DriverBloc>().add(BlockUnBlocDriver(driverId: driverDetails['id'] ?? 'unknown', isBlocked: false));
            });
          }),
        ],
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, Color color, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed == null ? Colors.grey[300] : color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }

  void _showImageDialog(BuildContext context, String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image not available')));
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 300,
              width: double.infinity,
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, String action, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Confirm $action', style: const TextStyle(fontWeight: FontWeight.w600)),
          content: Text('Are you sure you want to $action this driver?', style: TextStyle(color: Colors.grey[700])),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.teal)),
            ),
            ElevatedButton(
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text(action),
            ),
          ],
        );
      },
    );
  }
}
