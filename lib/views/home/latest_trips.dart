// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideadmin/controller/dash/bloc/dash_bloc.dart';

// class LatestTrips extends StatefulWidget {
//   const LatestTrips({super.key});

//   @override
//   State<LatestTrips> createState() => _LatestTripsState();
// }

// class _LatestTripsState extends State<LatestTrips> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<DashBloc>().add(FetchLatestTripsEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(onPressed: (){
// Navigator.pop(context);
// context.read<DashBloc>().add(FetchMostActiveDriversEvent());
//     context.read<DashBloc>().add(FetchTotalCompletedTripsEvent());
//     context.read<DashBloc>().add(FetchTotalTripReportEvent());
//         }, icon: Icon(Icons.arrow_back)),
//         title: const Text('Latest Trips'),
//         backgroundColor: Colors.blueAccent,
//         elevation: 4,
//       ),
//       body: BlocBuilder<DashBloc, DashState>(
//         builder: (context, state) {
//           if (state is DashLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is LatestTripLoaded) {
//             final trips = state.latestTrips['data'] as List<dynamic>;
//             if (trips.isEmpty) {
//               return const Center(child: Text('No trips available'));
//             }
//             return ListView.builder(
//               padding: const EdgeInsets.all(10),
//               itemCount: trips.length,
//               itemBuilder: (context, index) {
//                 final trip = trips[index];
//                 final user = trip['userId'];
//                 final driver = trip['driverId'];

//                 return Card(
//                   elevation: 5,
//                   margin: const EdgeInsets.only(bottom: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               user['name'],
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Chip(
//                               label: Text(
//                                 '₹${trip['fare'].toStringAsFixed(2)}',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               backgroundColor: Colors.green,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 5),
//                         Row(
//                           children: [
//                             const Icon(Icons.drive_eta, color: Colors.blue),
//                             const SizedBox(width: 5),
//                             Text(
//                               'Driver: ${driver['name']}',
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 5),
//                         Row(
//                           children: [
//                             const Icon(Icons.directions_car, color: Colors.orange),
//                             const SizedBox(width: 5),
//                             Text(
//                               'Distance: ${trip['distance']} km',
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ],
//                         ),
//                         const Divider(thickness: 1, height: 15),
//                         Row(
//                           children: [
//                             const Icon(Icons.location_on, color: Colors.red),
//                             const SizedBox(width: 5),
//                             Expanded(
//                               child: Text(
//                                 'Pickup: ${trip['pickUpLocation']}',
//                                 style: const TextStyle(fontSize: 14),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 5),
//                         Row(
//                           children: [
//                             const Icon(Icons.location_on_outlined, color: Colors.green),
//                             const SizedBox(width: 5),
//                             Expanded(
//                               child: Text(
//                                 'Drop: ${trip['dropOffLocation']}',
//                                 style: const TextStyle(fontSize: 14),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else if (state is DashError) {
//             return Center(
//               child: Text(
//                 state.error,
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             );
//           }
//           return const Center(child: Text('No data available'));
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/controller/dash/bloc/dash_bloc.dart';

class LatestTrips extends StatefulWidget {
  const LatestTrips({super.key});

  @override
  State<LatestTrips> createState() => _LatestTripsState();
}

class _LatestTripsState extends State<LatestTrips> {
  @override
  void initState() {
    super.initState();
    context.read<DashBloc>().add(FetchLatestTripsEvent());
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<DashBloc>().add(FetchMostActiveDriversEvent());
            context.read<DashBloc>().add(FetchTotalCompletedTripsEvent());
            context.read<DashBloc>().add(FetchTotalTripReportEvent());
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Latest Trips'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: BlocBuilder<DashBloc, DashState>(
        builder: (context, state) {
          if (state is DashLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LatestTripLoaded) {
            final trips = state.latestTrips['data'] as List<dynamic>;
            if (trips.isEmpty) {
              return const Center(child: Text('No trips available'));
            }
            return ListView.builder(
              padding: EdgeInsets.all(screenWidth * 0.03), // Padding based on screen width
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                final user = trip['userId'];
                final driver = trip['driverId'];

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: screenHeight * 0.02), // Margin based on screen height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04), // Padding based on screen width
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user['name'],
                              style: TextStyle(
                                fontSize: screenWidth * 0.05, // Responsive font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Chip(
                              label: Text(
                                '₹${trip['fare'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01), // Space based on screen height
                        Row(
                          children: [
                            const Icon(Icons.drive_eta, color: Colors.blue),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              'Driver: ${driver['name']}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04, // Responsive font size
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          children: [
                            const Icon(Icons.directions_car, color: Colors.orange),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              'Distance: ${trip['distance']} km',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04, // Responsive font size
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 1, height: 15),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                'Pickup: ${trip['pickUpLocation']}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035, // Responsive font size
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.green),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                'Drop: ${trip['dropOffLocation']}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035, // Responsive font size
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is DashError) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
