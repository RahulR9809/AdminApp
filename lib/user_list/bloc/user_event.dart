part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class FetchUsers extends UserEvent{}

class BlockUnBlocUser extends UserEvent{}

class BlockUnblockUserEvent extends UserEvent {
  final String userId;
  final bool isBlocked;

  BlockUnblockUserEvent({required this.userId, required this.isBlocked});
}