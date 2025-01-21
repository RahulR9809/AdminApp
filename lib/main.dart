import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/controller/login/login_bloc.dart';
import 'package:rideadmin/repositories/auth_service.dart';
import 'package:rideadmin/views/login/login_screen.dart';
import 'package:rideadmin/repositories/driver_service.dart';
import 'package:rideadmin/repositories/user_service.dart';
import 'package:rideadmin/controller/navbar/bottom_nav_bloc.dart';
import 'package:rideadmin/controller/driver/driver_bloc.dart';
import 'package:rideadmin/views/mainpage/mainpage.dart';
import 'package:rideadmin/controller/user/user_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BottomNavBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(authService: AuthService())..add(AuthCheckingEvent()),
        ),
        BlocProvider(
          create: (context) => DriverBloc(driverApiService: DriverApiService())..add(FetchDrivers()),
          // lazy: false,
        ),
        BlocProvider(
          create: (context) => UserBloc(UserApiService())..add(FetchUsers())
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is AuthenticatedState) {
              return const MainPage();
            } else if (state is UnauthenticatedState) {
              return const Login();
            } else if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Login();
          },
        ),
      ),
    );
  }
}
