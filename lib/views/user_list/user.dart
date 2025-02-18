
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/core/color.dart';
import 'package:rideadmin/controller/user/user_bloc.dart';
import 'package:rideadmin/widgets/status.dart';
import 'package:rideadmin/widgets/widgets.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  String searchQuery = '';
  String selectedStatus = 'All'; // To manage filter (All, Active, Blocked)
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUsers());
  }

  void _filterUsers(String query, String status) {
    context.read<UserBloc>().add(SearchFilterUsers(searchQuery: query, selectedStatus: status));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User List',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
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
                      controller: searchController,
                      onChanged: (query) {
                        _filterUsers(query, selectedStatus);
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search by name or email...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.filter_alt),
                          onPressed: () async {
                            final selectedFilter = await showMenu<String>(
                              context: context,
                              position: const RelativeRect.fromLTRB(
                                  200, 80, 16, 0), 
                              items: const [
                                PopupMenuItem(
                                  value: 'All',
                                  child: Text('All'),
                                ),
                                PopupMenuItem(
                                  value: 'Active',
                                  child: Text('Active'),
                                ),
                                PopupMenuItem(
                                  value: 'Blocked',
                                  child: Text('Blocked'),
                                ),
                              ],
                            );
                            if (selectedFilter != null) {
                              _filterUsers(searchQuery, selectedFilter);
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
          Expanded(
            child: BlocConsumer<UserBloc, UserState>(
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
                  final filteredUsers = state.users;

                  if (filteredUsers.isEmpty) {
                    return const Center(
                      child: Text(
                        'No users found.',
                        style: TextStyle(color: AppColors.neutralColor),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      final isBlocked = user.isBlocked;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.lightPrimary,
                            child: Icon(
                              Icons.person,
                              color: AppColors.iconPrimary,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            user.name,
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
                                user.email,
                                style: const TextStyle(
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
                                              userId: user.id,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
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
          ),
        ],
      ),
    );
  }
}
