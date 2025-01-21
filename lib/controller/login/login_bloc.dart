

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/model/login_model.dart';
import 'package:rideadmin/repositories/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  LoginBloc({required this.authService}) : super(LoginInitial()) {
    on<ButtonClickedEvent>((event, emit) async {
      if (event.username.isEmpty || event.password.isEmpty) {
        emit(ErrorState(errorMessage: 'Username and password cannot be empty'));
      } else {
        final token = await authService.login(event.username, event.password);
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          
          // Save the token inside LoginModel
          final loginModel = LoginModel(token: token);
          
          // Store the serialized LoginModel in SharedPreferences
          await prefs.setString('auth_token', loginModel.token);
          
          emit(LoadedState());
          if (kDebugMode) {
            print('Login successful, model stored in SharedPreferences: ${loginModel.token}');
          }
        }
      }
    });

    on<AuthCheckingEvent>((event, emit) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        String? savedLoginModelJson = prefs.getString('auth_token');

        if (savedLoginModelJson != null) {
          emit(AuthenticatedState());
        } else {
          emit(UnauthenticatedState()); 
        }
      } catch (e) {
        emit(ErrorState(errorMessage: 'An error occurred while checking authentication'));
      }
    });
  }
}
