import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideadmin/controller/auth_service.dart';
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
        emit(LoadingState());

        try {
          final token = await authService.login(event.username, event.password);
          if (kDebugMode) {
            print('Token retrieved from authService: $token');
          }

          if (token != null) {
            final prefs = await SharedPreferences.getInstance();
            
            await prefs.setString('auth_token', token);
            if (kDebugMode) {
              print('Login successful, token stored in SharedPreferences: $token');
            }

            emit(LoadedState());

            String? savedToken = prefs.getString('auth_token');
            if (savedToken != null) {
              if (kDebugMode) {
                print('Token retrieved from SharedPreferences: $savedToken');
              }
            } else {
              if (kDebugMode) {
                print('Token not found in SharedPreferences after saving.');
              }
            }

          } else {
            emit(ErrorState(errorMessage: 'Invalid username or password'));
          }

        } catch (e) {
          emit(ErrorState(errorMessage: 'Login failed. Please try again.'));
          if (kDebugMode) {
            print('Error during login: $e');
          }
        }
      }
    });
  }
}
