import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/authentication/LoginPage/bloc/login_bloc.dart';
import 'package:rideadmin/authentication/LoginPage/login.dart';
import 'package:rideadmin/controller/auth_service.dart';
import 'package:rideadmin/controller/driver_service.dart';
import 'package:rideadmin/drivers_list.dart/bloc/driver_bloc.dart';
import 'package:rideadmin/drivers_list.dart/drivers.dart';

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
          create: (context) => LoginBloc(authService: AuthService())..add(AuthCheckingEvent()),
        ),
        BlocProvider(
          create: (context) => DriverBloc(driverApiService: DriverApiService())..add(FetchDrivers()),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is AuthenticatedState) {
              return const DriverListScreen();
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
