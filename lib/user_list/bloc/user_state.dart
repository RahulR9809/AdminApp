part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class UserLoading extends UserState{}

class UserListLoaded extends UserState{
final List<dynamic>users;

  UserListLoaded({required this.users});

}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class UserActionSuccess extends UserState{
  final String message;

  UserActionSuccess( this.message);
}