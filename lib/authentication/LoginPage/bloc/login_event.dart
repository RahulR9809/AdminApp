part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class ButtonClickedEvent extends LoginEvent{
    final String username;
  final String password;

  ButtonClickedEvent({required this.username, required this.password});
}

class AuthCheckingEvent extends LoginEvent{}