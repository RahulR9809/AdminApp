import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/controller/navbar/bottom_nav_bloc.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        int currentIndex = 0; 
        if (state is BottomNavigationState) {
          currentIndex = state.selectedIndex;
        } else if (state is BottomNavInitial) {
          currentIndex = 0; 
        }
        return BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
              backgroundColor: Colors.amber,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.verified_user),
              label: '',
            ),
          ],
          currentIndex: currentIndex, 
          onTap: (index) {
            context.read<BottomNavBloc>().add(UpdateTab(index)); 
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
        );
      },
    );
  }
}
