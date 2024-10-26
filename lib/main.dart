import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/LoginPage/bloc/login_bloc.dart';
import 'package:rideadmin/LoginPage/login.dart';
import 'package:rideadmin/controller/auth_service.dart';
import 'package:rideadmin/drivers_list.dart/drivers.dart';
import 'package:rideadmin/profilePage/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String? token = prefs.getString('auth_token');
    
    if (token != null) {
      if (kDebugMode) {
        print('Token found in SharedPreferences: $token');
      }
      setState(() {
        _isLoggedIn = true; 
      });
    } else {
      if (kDebugMode) {
        print('No token found in SharedPreferences.');
      }
      setState(() {
        _isLoggedIn = false;  
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
   debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
     
      ),
      home: _isLoggedIn ?  DriverListScreen() :BlocProvider(
        create: (context) => LoginBloc(authService: AuthService()),
        child: const Login()
      )
      // home:DriverListScreen()
    );
  }
}
