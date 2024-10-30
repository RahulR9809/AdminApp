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
        final token = await authService.login(event.username, event.password);
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          emit(LoadedState());
          if (kDebugMode) {
            print(
                'Login successful, token stored in SharedPreferences: $token');
          }
        }
      }
    });

  on<AuthCheckingEvent>(
  (event, emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedToken = prefs.getString('auth_token');

      if (savedToken != null) {
        emit(AuthenticatedState());
      } else {
        emit(UnauthenticatedState()); // Ensure UnauthenticatedState is emitted
        print('Error: No token found');
      }
    } catch (e) {
      emit(ErrorState(errorMessage: 'An error occurred while checking authentication'));
      print('Exception caught: $e');
    }
  },
);

  }
}
