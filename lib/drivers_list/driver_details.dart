import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/core/color.dart';
import 'package:rideadmin/drivers_list/bloc/driver_bloc.dart';
import 'package:rideadmin/widgets/status.dart';
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
    return BlocListener<DriverBloc, DriverState>(
      listener: (context, state) {
        if (state is DriverActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is DriverError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Driver Details',
          onLeadingPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: AppColors.primaryColor,
          icon: const Icon(Icons.arrow_back),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(imageUrl: driverDetails['profileUrl']),
              const SizedBox(height: 24),
              SectionHeader(title: "Driver Information"),
              DetailRow(
                  icon: Icons.person,
                  title: "Name",
                  value: driverDetails['name'] ?? 'No name provided'),
              DetailRow(
                  icon: Icons.email,
                  title: "Email",
                  value: driverDetails['email'] ?? 'No email provided'),
              DetailRow(
                icon: Icons.verified_user,
                title: "Status",
                value: driverDetails['isAccepted'] == false
                    ? 'Pending Approval'
                    : 'Approved',
              ),
              const Divider(
                  height: 30, thickness: 1.5, color: AppColors.neutralColor),
              SectionHeader(title: "Vehicle Details"),
              DetailRow(
                  icon: Icons.directions_car,
                  title: "Vehicle Type",
                  value: vehicleDetails?['vehicle_type'] ?? 'No vehicle type'),
              DetailRow(
                  icon: Icons.confirmation_number,
                  title: "RC Number",
                  value: vehicleDetails?['rc_Number'] ?? 'No RC number'),
              const SizedBox(height: 16),
              SectionHeader(title: "Documents"),
              ImageSection(
                  title: "License Image:",
                  imageUrl: driverDetails['licenseUrl'],
                  onImageTap: _showImageDialog),
              ImageSection(
                  title: "Permit Image:",
                  imageUrl: vehicleDetails?['permitUrl'],
                  onImageTap: _showImageDialog),
              const SizedBox(height: 30),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
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
              ActionButton(
                label: 'Accept',
                color: AppColors.successColor,
                onPressed: () {
                  _showConfirmationDialog(context, 'Accept', () {
                    context
                        .read<DriverBloc>()
                        .add(AcceptDriver(context,driverId: driverDetails['id']));
                  }, content: 'Are you sure you want to accept this driver?');
                },
              ),
            if (isAccepted) ...[
              ActionButton(
                label: 'Block',
                color: AppColors.blockedColor,
                onPressed: isBlocked
                    ? null
                    : () {
                        _showConfirmationDialog(context, 'Block', () {
                          context.read<DriverBloc>().add(BlockUnBlocDriver(
                             context, driverId: driverDetails['id'], isBlocked: true));
                        },
                            content:
                                'Are you sure you want to block this driver?');
                      },
              ),
              ActionButton(
                label: 'Unblock',
                color: AppColors.blue,
                onPressed: !isBlocked
                    ? null
                    : () {
                        _showConfirmationDialog(context, 'Unblock', () {
                          context.read<DriverBloc>().add(BlockUnBlocDriver(
                             context, driverId: driverDetails['id'], isBlocked: false));
                        },
                            content:
                                'Are you sure you want to unblock this driver?');
                      },
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
