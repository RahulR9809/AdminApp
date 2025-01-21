import 'package:flutter/material.dart';
import 'package:rideadmin/core/color.dart';
import 'package:rideadmin/widgets/widgets.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryColor),
            child: Center(
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: AppColors.primaryColor),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: AppColors.primaryColor),
            title: const Text('Manage Drivers'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.car_rental, color: AppColors.primaryColor),
            title: const Text('Trips Overview'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ConfirmationDialog(
                    action: 'logout',
                    onConfirm: () {
                      logout(context);
                    }, content: 'Are you sure you want to log out?',
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
