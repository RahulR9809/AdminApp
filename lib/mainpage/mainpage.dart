
// class ScreenMainPage extends StatelessWidget {
//   ScreenMainPage({super.key});

//   final List<Widget> _pages = [
//     const ScreenHome(),
//     const ScreenProfile(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: BlocBuilder<BottomNavBloc, BottomNavState>(
//           builder: (context, state) {
//             if (state is HomePageState) {
//               return _pages[0];  // Home Page
//             } else if (state is ProfilePageState) {
//               return _pages[1];  // Profile Page
//             }
//             return Container(); // Fallback
//           },
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationWidget(),
//     );
//   }
// }
