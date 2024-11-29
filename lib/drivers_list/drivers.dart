import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/core/color.dart';
import 'package:rideadmin/core/style.dart';
import 'package:rideadmin/drivers_list/bloc/driver_bloc.dart';
import 'package:rideadmin/drivers_list/driver_details.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {


  @override
void initState() {
  super.initState();
  context.read<DriverBloc>().add(FetchDrivers());
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Drivers List'),
         
          ],
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocBuilder<DriverBloc, DriverState>(
        builder: (context, state) {
          if (state is DriverLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DriverDetailLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => DriverDetailsPage(
                  driverDetails: state.driverDetails,
                  vehicleDetails: state.vehicleDetails,
                ),
              ))
                  .then((_) {
                context.read<DriverBloc>().add(FetchDrivers());
              });
            });
          } else if (state is DriverListLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(AppSizes.listPadding),
              itemCount: state.drivers.length,
              itemBuilder: (context, index) {
                final driver = state.drivers[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
                  ),
                  elevation: AppSizes.cardElevation,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppSizes.listPadding),
                    leading: const CircleAvatar(
                      radius: AppSizes.avatarRadius,
                      backgroundColor: AppColors.lightPrimary,
                      child: Icon(
                        Icons.person,
                        color: AppColors.iconPrimary,
                        size: AppSizes.avatarRadius,
                      ),
                    ),
                    title: Text(
                      driver['name'] ?? 'No Name Available',
                      style: AppStyles.titleStyle,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          driver['email'] ?? 'No Email Available',
                          style: AppStyles.subtitleStyle,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              driver['isBlocked'] == true
                                  ? Icons.block
                                  : (driver['isAccepted'] == false
                                      ? Icons.pending
                                      : Icons.check_circle),
                              color: driver['isBlocked'] == true
                                  ? AppColors.blockedColor
                                  : (driver['isAccepted'] == false
                                      ? AppColors.pendingColor
                                      : AppColors.approvedColor),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              driver['isBlocked'] == true
                                  ? 'Blocked'
                                  : (driver['isAccepted'] == false
                                      ? 'Pending'
                                      : 'Approved'),
                              style: AppStyles.statusStyle.copyWith(
                                color: driver['isBlocked'] == true
                                    ? AppColors.blockedColor
                                    : (driver['isAccepted'] == false
                                        ? AppColors.pendingColor
                                        : AppColors.approvedColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      final driverId = driver['_id'];
                      if (driverId != null) {
                        context
                            .read<DriverBloc>()
                            .add(FetchDriverDetails(driverId));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Driver ID is missing.')),
                        );
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is DriverError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          return Container();
        },
      ),
    );
  }
}
