import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/Home/homepage.dart';
import 'package:rideadmin/customBottomNav/bloc/bottom_nav_bloc.dart';
import 'package:rideadmin/customBottomNav/nav_page.dart';
import 'package:rideadmin/drivers_list/drivers.dart';
import 'package:rideadmin/user_list/user.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
     AdminHomePage(), // Your home page (index 0)
    const DriverListScreen(), // Your car page (index 1)
    const UserListScreen(), // Your profile page (index 2)
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child: Scaffold(
        body: BlocBuilder<BottomNavBloc, BottomNavState>(
          builder: (context, state) {
            int currentIndex = 0; // Default index to home
            if (state is BottomNavigationState) {
              currentIndex = state.selectedIndex; // Current index from state
            }
            return IndexedStack(
              index: currentIndex,
              children: _pages,
            );
          },
        ),
        bottomNavigationBar:
            const CustomBottomNavBar(), // Add your custom bottom nav bar here
      ),
    );
  }
}
