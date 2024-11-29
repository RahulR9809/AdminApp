
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rideadmin/controller/user_service.dart';
// import 'package:rideadmin/core/color.dart';
// import 'package:rideadmin/user_list/bloc/user_bloc.dart';
// import 'package:rideadmin/widgets/widgets.dart'; // Import AppColors

// class UserListScreen extends StatefulWidget {
//   const UserListScreen({super.key});

//   @override
//   State<UserListScreen> createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   final UserApiService _userApiService = UserApiService();

//   @override
//   void initState() {
//     super.initState();
//     context.read<UserBloc>().add(FetchUsers());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User List'),
//         backgroundColor: AppColors.primaryColor,
//       ),
//       body: BlocBuilder<UserBloc, UserState>(
//         builder: (context, state) {
//           if (state is UserLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is UserListLoaded) {
//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: state.users.length,
//               itemBuilder: (context, index) {
//                 final user = state.users[index];
//                 final isBlocked = user['isBlocked'] == true;
//                 return Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   elevation: 6,
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(16),
//                     leading: CircleAvatar(
//                       radius: 30,
//                       backgroundColor: AppColors.lightPrimary,
//                       child: Icon(
//                         Icons.person,
//                         color: AppColors.iconPrimary,
//                         size: 30,
//                       ),
//                     ),
//                     title: Text(
//                       user['name'] ?? 'No Name Available',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.blackColor,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 8),
//                         Text(
//                           user['email'] ?? 'No Email Available',
//                           style: TextStyle(
//                             color: AppColors.neutralColor,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Icon(
//                               isBlocked ? Icons.block : Icons.check_circle,
//                               color: isBlocked
//                                   ? AppColors.blockedColor
//                                   : AppColors.approvedColor,
//                               size: 18,
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               isBlocked ? 'Blocked' : 'Active',
//                               style: TextStyle(
//                                 color: isBlocked
//                                     ? AppColors.blockedColor
//                                     : AppColors.approvedColor,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     trailing: ElevatedButton(
//                       onPressed: () {
//                         // Show the custom ConfirmationDialog
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return ConfirmationDialog(
//                               action: isBlocked ? 'Unblock' : 'Block',
//                               onConfirm: () {
//                                 // Handle the block/unblock action
//                                 context.read<UserBloc>().add(BlockUnblockUserEvent(
//                                   userId: user['_id'],
//                                   isBlocked: !isBlocked,
//                                 ));
//                               }, content:  isBlocked 
//       ? 'Are you sure you want to unblock this driver?' 
//       : 'Are you sure you want to block this driver?',
//                             );
//                           },
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             isBlocked ? AppColors.approvedColor : AppColors.blockedColor,
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                       ),
//                       child: Text(
//                         isBlocked ? 'Unblock' : 'Block',
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else if (state is UserError) {
//             return Center(
//               child: Text(
//                 'Error: ${state.message}',
//                 style: const TextStyle(color: AppColors.blockedColor),
//               ),
//             );
//           }
//           return const Center(
//             child: Text(
//               'No data available.',
//               style: TextStyle(color: AppColors.neutralColor),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/controller/user_service.dart';
import 'package:rideadmin/core/color.dart';
import 'package:rideadmin/user_list/bloc/user_bloc.dart';
import 'package:rideadmin/widgets/status.dart';
import 'package:rideadmin/widgets/widgets.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserApiService _userApiService = UserApiService();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserActionSuccess) {
            StatusDialog.show(
              context: context,
              message: state.message,
            );
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserListLoaded) {
            if (state.users.isEmpty) {
              return const Center(
                child: Text(
                  'No users found.',
                  style: TextStyle(color: AppColors.neutralColor),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                final isBlocked = user['isBlocked'] == true;
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
                      backgroundColor: AppColors.lightPrimary,
                      child: Icon(
                        Icons.person,
                        color: AppColors.iconPrimary,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      user['name'] ?? 'No Name Available',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          user['email'] ?? 'No Email Available',
                          style: TextStyle(
                            color: AppColors.neutralColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              isBlocked ? Icons.block : Icons.check_circle,
                              color: isBlocked
                                  ? AppColors.blockedColor
                                  : AppColors.approvedColor,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isBlocked ? 'Blocked' : 'Active',
                              style: TextStyle(
                                color: isBlocked
                                    ? AppColors.blockedColor
                                    : AppColors.approvedColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ConfirmationDialog(
                              action: isBlocked ? 'Unblock' : 'Block',
                              content: isBlocked
                                  ? 'Are you sure you want to unblock this user?'
                                  : 'Are you sure you want to block this user?',
                              onConfirm: () {
                                context.read<UserBloc>().add(
                                      BlockUnblockUserEvent(
                                        userId: user['_id'],
                                        isBlocked: !isBlocked,
                                      ),
                                    );
                              },
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBlocked
                            ? AppColors.approvedColor
                            : AppColors.blockedColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        isBlocked ? 'Unblock' : 'Block',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is UserError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: AppColors.blockedColor),
              ),
            );
          }
          return const Center(
            child: Text(
              'No data available.',
              style: TextStyle(color: AppColors.neutralColor),
            ),
          );
        },
      ),
    );
  }
}
