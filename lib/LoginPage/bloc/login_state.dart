part of 'login_bloc.dart';

@immutable
abstract  class LoginState {}

final class LoginInitial extends LoginState {}

final class LoadingState extends LoginState{}

final class LoadedState extends LoginState{}

final class ErrorState extends LoginState {
  final String errorMessage;

  ErrorState({required this.errorMessage});
}