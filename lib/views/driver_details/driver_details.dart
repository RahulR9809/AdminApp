import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/core/color.dart';
import 'package:rideadmin/controller/driver/driver_bloc.dart';
import 'package:rideadmin/widgets/widgets.dart';

class DriverDetailsPage extends StatelessWidget {
  final Map<String, dynamic> driverDetails;
  final Map<String, dynamic>? vehicleDetails;
  const DriverDetailsPage({
    super.key,
    required this.driverDetails,
    this.vehicleDetails,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<DriverBloc>().add(FetchDrivers());
        return true;
      },
      child: BlocListener<DriverBloc, DriverState>(
        listener: (context, state) {
          if (state is DriverActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is DriverError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to Load')),
            );
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Driver Details',
            titleStyle: const TextStyle(color: AppColors.white),
            onLeadingPressed: () {
              context.read<DriverBloc>().add(FetchDrivers());
              Navigator.pop(context);
            },
            backgroundColor: AppColors.primaryColor,
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
            ),
          ),
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileHeader(context),
                const SizedBox(height: 20),
                _buildDetailsSection(
                  title: "Driver Information",
                  children: _buildDriverInfo(),
                ),
                const SizedBox(height: 20),
                _buildDetailsSection(
                  title: "Vehicle Details",
                  children: _buildVehicleInfo(),
                ),
                const SizedBox(height: 20),
                _buildDetailsSection(
                  title: "Documents",
                  children: _buildDocuments(),
                ),
                const SizedBox(height: 30),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileAvatar(imageUrl: driverDetails['profileUrl']),
            const SizedBox(height: 16),
            Text(
              driverDetails['name'] ?? 'No name provided',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              driverDetails['email'] ?? 'No email provided',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.neutralColor,
                  ),
            ),
            Chip(
              label: Text(
                driverDetails['isAccepted'] == false
                    ? 'Pending Approval'
                    : 'Approved',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: driverDetails['isAccepted'] == false
                  ? AppColors.blockedColor
                  : AppColors.successColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const Divider(height: 20, thickness: 1.5),
            ...children,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDriverInfo() {
    return [
      DetailRow(
        icon: Icons.person,
        title: "Name",
        value: driverDetails['name'] ?? 'No name provided',
      ),
      DetailRow(
        icon: Icons.email,
        title: "Email",
        value: driverDetails['email'] ?? 'No email provided',
      ),
      DetailRow(
        icon: Icons.verified_user,
        title: "Status",
        value: driverDetails['isAccepted'] == false
            ? 'Pending Approval'
            : 'Approved',
      ),
    ];
  }

  List<Widget> _buildVehicleInfo() {
    return [
      DetailRow(
        icon: Icons.directions_car,
        title: "Vehicle Type",
        value: vehicleDetails?['vehicle_type'] ?? 'No vehicle type',
      ),
      DetailRow(
        icon: Icons.confirmation_number,
        title: "RC Number",
        value: vehicleDetails?['rc_Number'] ?? 'No RC number',
      ),
    ];
  }

  List<Widget> _buildDocuments() {
    return [
      ImageSection(
        title: "License Image:",
        imageUrl: driverDetails['licenseUrl'],
        onImageTap: _showImageDialog,
      ),
      ImageSection(
        title: "Permit Image:",
        imageUrl: vehicleDetails?['permitUrl'],
        onImageTap: _showImageDialog,
      ),
    ];
  }

  void _showImageDialog(BuildContext context, String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Image not available')));
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  Widget _buildActionButtons(BuildContext context) {
    return BlocBuilder<DriverBloc, DriverState>(
      buildWhen: (previous, current) => current is DriverButtonState,
      builder: (context, state) {
        bool isAccepted = driverDetails['isAccepted'] ?? false;
        bool isBlocked = driverDetails['isBlocked'] ?? false;

        if (state is DriverButtonState) {
          isAccepted = state.isAccepted;
          isBlocked = state.isBlocked;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (!isAccepted)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _showConfirmationDialog(context, 'Accept', () {
                    context.read<DriverBloc>().add(
                        AcceptDriver(context, driverId: driverDetails['id']));
                  }, content: 'Are you sure you want to accept this driver?');
                },
                child: const Text('Accept'),
              ),
            if (isAccepted) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blockedColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isBlocked
                    ? null
                    : () {
                        _showConfirmationDialog(context, 'Block', () {
                          context.read<DriverBloc>().add(BlockUnBlocDriver(
                              context,
                              driverId: driverDetails['id'],
                              isBlocked: true));
                          if (driverDetails['id'] == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Driver ID is missing')),
                            );
                            return;
                          }
                        },
                            content:
                                'Are you sure you want to block this driver?');
                      },
                child: const Text(
                  'Block',
                  style: TextStyle(color: AppColors.lightTeal),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.approvedColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: !isBlocked
                    ? null
                    : () {
                        _showConfirmationDialog(context, 'Unblock', () {
                          context.read<DriverBloc>().add(BlockUnBlocDriver(
                              context,
                              driverId: driverDetails['id'],
                              isBlocked: false));
                        },
                            content:
                                'Are you sure you want to unblock this driver?');
                      },
                child: const Text(
                  'Unblock',
                  style: TextStyle(color: AppColors.lightTeal),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String action, VoidCallback onConfirm,
      {required String content}) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          action: action,
          onConfirm: onConfirm,
          content: content,
        );
      },
    );
  }
}
