import 'package:flutter/material.dart';
import 'package:rideadmin/core/color.dart';
import 'package:rideadmin/widgets/widgets.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
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
            leading: Icon(Icons.dashboard, color: AppColors.primaryColor),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              // Handle navigation to Dashboard
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: AppColors.primaryColor),
            title: Text('Manage Drivers'),
            onTap: () {
              Navigator.pop(context);
              // Handle navigation to Driver Management
            },
          ),
          ListTile(
            leading: Icon(Icons.car_rental, color: AppColors.primaryColor),
            title: Text('Trips Overview'),
            onTap: () {
              Navigator.pop(context);
              // Handle navigation to Trips Overview
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return ConfirmationDialog(
                    action: 'logout',
                    onConfirm: () {
                      // Call your logout function here
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
