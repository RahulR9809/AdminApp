

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideadmin/core/color.dart';
// import 'package:rideadmin/core/style.dart';
// import 'package:rideadmin/controller/driver/driver_bloc.dart';
// import 'package:rideadmin/views/driver_details/driver_details.dart';

// class DriverListScreen extends StatefulWidget {
//   const DriverListScreen({super.key});

//   @override
//   State<DriverListScreen> createState() => _DriverListScreenState();
// }

// class _DriverListScreenState extends State<DriverListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Trigger FetchDrivers event
//     context.read<DriverBloc>().add(FetchDrivers());
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Drivers List',style: TextStyle(color: AppColors.white),),
//         backgroundColor: AppColors.primaryColor
//       ),
//       body: Column(
//         children: [
//           // Search Bar with Filter Icon
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Card(
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: TextField(
//   onChanged: (query) {
//     // Emit the SearchDriver event with the current query
//     context.read<DriverBloc>().add(SearchDriver(query));
//   },
//   decoration: InputDecoration(
//     contentPadding: const EdgeInsets.symmetric(vertical: 15),
//     prefixIcon: const Icon(Icons.search),
//     hintText: 'Search Drivers',
//     suffixIcon:  IconButton(
//             icon: const Icon(Icons.filter_alt),
//             onPressed: () async {
//               // Show dropdown menu for filtering
//               final selectedStatus = await showMenu<String>(
//                 context: context,
//                 position: const RelativeRect.fromLTRB(50, 5, 26, 0), 
//                 items: <PopupMenuEntry<String>>[
//                   const PopupMenuItem(
//                     value: 'All',
//                     child: Text('All'),
//                   ),
//                   const PopupMenuItem(
//                     value: 'Pending',
//                     child: Text('Pending'),
//                   ),
//                   const PopupMenuItem(
//                     value: 'Approved',
//                     child: Text('Approved'),
//                   ),
//                 ],
//               );
//               if (selectedStatus != null) {
//                 // Emit the FilterDriver event with the selected status
//                 context.read<DriverBloc>().add(FilterDriver(selectedStatus, ''));
//               }
//             },
//           ),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(12),
//       borderSide: BorderSide.none,
//     ),
//     filled: true,
//     fillColor: Colors.white,
//   ),
// ),

//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Driver List Section
//           Expanded(
//             child: BlocBuilder<DriverBloc, DriverState>(
//               builder: (context, state) {
//                 if (state is DriverLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is DriverListLoaded) {
//                   var drivers = state.drivers;

//                   // Display a message if no drivers are available after filtering
//                   if (drivers.isEmpty) {
//                     return const Center(child: Text('No drivers found.'));
//                   }

//                   return ListView.builder(
//                     padding: const EdgeInsets.all(AppSizes.listPadding),
//                     itemCount: drivers.length,
//                     itemBuilder: (context, index) {
//                       final driver = drivers[index];
//                       return Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(AppSizes.cardBorderRadius),
//                         ),
//                         elevation: AppSizes.cardElevation,
//                         margin: const EdgeInsets.symmetric(vertical: 10),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(
//                               AppSizes.listPadding),
//                           leading: const CircleAvatar(
//                             radius: AppSizes.avatarRadius,
//                             backgroundColor: AppColors.lightPrimary,
//                             child: Icon(
//                               Icons.person,
//                               color: AppColors.iconPrimary,
//                               size: AppSizes.avatarRadius,
//                             ),
//                           ),
//                           title: Text(
//                             driver['name'] ?? 'No Name Available',
//                             style: AppStyles.titleStyle,
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 8),
//                               Text(
//                                 driver['email'] ?? 'No Email Available',
//                                 style: AppStyles.subtitleStyle,
//                               ),
//                               const SizedBox(height: 4),
//                               Row(
//                                 children: [
//                                   Icon(
//                                     driver['isBlocked'] == true
//                                         ? Icons.block
//                                         : (driver['isAccepted'] == false
//                                             ? Icons.pending
//                                             : Icons.check_circle),
//                                     color: driver['isBlocked'] == true
//                                         ? AppColors.blockedColor
//                                         : (driver['isAccepted'] == false
//                                             ? AppColors.pendingColor
//                                             : AppColors.approvedColor),
//                                     size: 18,
//                                   ),
//                                   const SizedBox(width: 6),
//                                   Text(
//                                     driver['isBlocked'] == true
//                                         ? 'Blocked'
//                                         : (driver['isAccepted'] == false
//                                             ? 'Pending'
//                                             : 'Approved'),
//                                     style: AppStyles.statusStyle.copyWith(
//                                       color: driver['isBlocked'] == true
//                                           ? AppColors.blockedColor
//                                           : (driver['isAccepted'] == false
//                                               ? AppColors.pendingColor
//                                               : AppColors.approvedColor),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           trailing: const Icon(Icons.arrow_forward_ios),
//                         onTap: () {
//   final driverId = driver['_id'];
//   if (driverId != null) {
//     // Emit FetchDriverDetails event
//     context.read<DriverBloc>().add(FetchDriverDetails(driverId));
    
//     // Navigate to DriverDetailsPage with necessary details
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DriverDetailsPage(
//           driverDetails: driver, // Pass the driver details
//           vehicleDetails: driver['vehicleDetails'], // Adjust as per your structure
//         ),
//       ),
//     );
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Driver ID is missing.')),
//     );
//   }
// },

//                         ),
//                       );
//                     },
//                   );
//                 } else if (state is DriverError) {
//                   return Center(
//                     child: Text('Error: ${state.message}'),
//                   );
//                 }
//                 return Container();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/core/color.dart';
import 'package:rideadmin/core/style.dart';
import 'package:rideadmin/controller/driver/driver_bloc.dart';
import 'package:rideadmin/views/driver_details/driver_details.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger FetchDrivers event
    context.read<DriverBloc>().add(FetchDrivers());
  }


  @override
  Widget build(BuildContext context) {
    return  BlocListener<DriverBloc, DriverState>(
  listener: (context, state) {
    if (state is DriverDetailLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DriverDetailsPage(
            driverDetails: state.driverDetails,
            vehicleDetails: state.vehicleDetails,
          ),
        ),
      );
    } else if (state is DriverError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },child:  Scaffold(
      appBar: AppBar(
        title: const Text('Drivers List',style: TextStyle(color: AppColors.white),),
        backgroundColor: AppColors.primaryColor
      ),
      body: Column(
        children: [
          // Search Bar with Filter Icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
  onChanged: (query) {
    // Emit the SearchDriver event with the current query
    context.read<DriverBloc>().add(SearchDriver(query));
  },
  decoration: InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 15),
    prefixIcon: const Icon(Icons.search),
    hintText: 'Search Drivers',
    suffixIcon:  IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              // Show dropdown menu for filtering
              final selectedStatus = await showMenu<String>(
                context: context,
                position: const RelativeRect.fromLTRB(50, 5, 26, 0), 
                items: <PopupMenuEntry<String>>[
                  const PopupMenuItem(
                    value: 'All',
                    child: Text('All'),
                  ),
                  const PopupMenuItem(
                    value: 'Pending',
                    child: Text('Pending'),
                  ),
                  const PopupMenuItem(
                    value: 'Approved',
                    child: Text('Approved'),
                  ),
                ],
              );
              if (selectedStatus != null) {
                // Emit the FilterDriver event with the selected status
                context.read<DriverBloc>().add(FilterDriver(selectedStatus, ''));
              }
            },
          ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.white,
  ),
),

                  ),
                ),
              ],
            ),
          ),
          // Driver List Section
          Expanded(
            child: BlocBuilder<DriverBloc, DriverState>(
              builder: (context, state) {
                if (state is DriverLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DriverListLoaded) {
                  var drivers = state.drivers;

                  // Display a message if no drivers are available after filtering
                  if (drivers.isEmpty) {
                    return const Center(child: Text('No drivers found.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.listPadding),
                    itemCount: drivers.length,
                    itemBuilder: (context, index) {
                      final driver = drivers[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.cardBorderRadius),
                        ),
                        elevation: AppSizes.cardElevation,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(
                              AppSizes.listPadding),
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
    // Emit FetchDriverDetails event
    context.read<DriverBloc>().add(FetchDriverDetails(driverId));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Driver ID is missing.')),
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
          ),
        ],
      ),
    ));
  }
}
