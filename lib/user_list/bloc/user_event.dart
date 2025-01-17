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


class SearchFilterUsers extends UserEvent {
  final String searchQuery;
  final String selectedStatus;

  SearchFilterUsers({required this.searchQuery, required this.selectedStatus});
}