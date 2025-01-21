import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/views/home/homepage.dart';
import 'package:rideadmin/controller/navbar/bottom_nav_bloc.dart';
import 'package:rideadmin/views/customBottomNav/nav_page.dart';
import 'package:rideadmin/views/driver_list/drivers.dart';
import 'package:rideadmin/views/user_list/user.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
     const AdminHomePage(),
    const DriverListScreen(), 
    const UserListScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child: Scaffold(
        body: BlocBuilder<BottomNavBloc, BottomNavState>(
          builder: (context, state) {
            int currentIndex = 0; 
            if (state is BottomNavigationState) {
              currentIndex = state.selectedIndex; 
            }
            return IndexedStack(
              index: currentIndex,
              children: _pages,
            );
          },
        ),
        bottomNavigationBar:
            const CustomBottomNavBar(),
      ),
    );
  }
}
