import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/authentication/LoginPage/login.dart';
import 'package:rideadmin/drivers_list.dart/bloc/driver_bloc.dart';
import 'package:rideadmin/drivers_list.dart/driver_details.dart';
import 'package:rideadmin/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Drivers List',
          onLeadingPressed: () => logout(context),
          backgroundColor: Colors.blueGrey,
          icons: const Icon(Icons.arrow_back)),
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
                // Reset state to DriverListLoaded after coming back
                context.read<DriverBloc>().add(FetchDrivers());
              });
            });
          } else if (state is DriverListLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.drivers.length,
              itemBuilder: (context, index) {
                final driver = state.drivers[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueGrey[100],
                      child: Icon(
                        Icons.person,
                        color: Colors.blueGrey[900],
                        size: 30,
                      ),
                    ),
                    title: Text(
                      driver['name'] ?? 'No Name Available',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          driver['email'] ?? 'No Email Available',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
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
                                  ? Colors.red
                                  : (driver['isAccepted'] == false
                                      ? Colors.orange
                                      : Colors.green),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              driver['isBlocked'] == true
                                  ? 'Blocked'
                                  : (driver['isAccepted'] == false
                                      ? 'Pending'
                                      : 'Approved'),
                              style: TextStyle(
                                color: driver['isBlocked'] == true
                                    ? Colors.red
                                    : (driver['isAccepted'] == false
                                        ? Colors.orange
                                        : Colors.green),
                                fontWeight: FontWeight.bold,
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
