
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class BottomNavigationWidget extends StatelessWidget {
//   const BottomNavigationWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BottomNavBloc, BottomNavState>(
//       builder: (context, state) {
//         int currentIndex = 0;
//         if (state is ProfilePageState) {
//           currentIndex = 1;
//         }

//         return BottomNavigationBar(
//           currentIndex: currentIndex,
//           onTap: (index) {
//             if (index == 0) {
//               context.read<BottomNavBloc>().add(NavigateToHome());
//             } else if (index == 1) {
//               context.read<BottomNavBloc>().add(NavigateToProfile());
//             }
//           },
//           elevation: 0,
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.black,
//           selectedItemColor: Colors.grey,
//           unselectedItemColor: Colors.white,
//           selectedIconTheme: const IconThemeData(color: Colors.blue),
//           unselectedIconTheme: const IconThemeData(color: Colors.grey),
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'Profile',
//             ),
//           ],
//         );
//       },
//     );
//   }
// }