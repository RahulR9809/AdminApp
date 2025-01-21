



// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:rideadmin/repositories/user_service.dart';

// part 'user_event.dart';
// part 'user_state.dart';

// class UserBloc extends Bloc<UserEvent, UserState> {
//   final UserApiService userApiService;

//   List<Map<String, dynamic>> allUsers = []; 

//   UserBloc(this.userApiService) : super(UserInitial()) {
//     on<FetchUsers>(_onFetchUsers);
//     on<BlockUnblockUserEvent>(_onBlockUnblockUserEvent);
//     on<SearchFilterUsers>(_onSearchFilterUsers);
//   }

//   Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
//     emit(UserLoading());
//     try {
//       final users = await UserApiService.getAllusers();
//       if (users.isNotEmpty) {
//         allUsers =  List<Map<String, dynamic>>.from(users);
//         emit(UserListLoaded(users: users)); // Emit all users initially
//       } else {
//         emit(UserError('No users found'));
//       }
//     } catch (e) {
//       emit(UserError('Failed to load users'));
//     }
//   }

//   Future<void> _onBlockUnblockUserEvent(
//       BlockUnblockUserEvent event, Emitter<UserState> emit) async {
//     try {
//       await userApiService.blocunblockUser(event.userId, event.isBlocked);
//       add(FetchUsers()); // Refresh the user list after blocking/unblocking
//       emit(UserActionSuccess(
//         event.isBlocked ? 'User blocked successfully' : 'User unblocked successfully',
//       ));
//     } catch (e) {
//       emit(UserError('Failed to block/unblock user'));
//     }
//   }

//   void _onSearchFilterUsers(
//       SearchFilterUsers event, Emitter<UserState> emit) {
//     final filteredUsers = allUsers.where((user) {
//       final matchesQuery = user['name']
//               .toLowerCase()
//               .contains(event.searchQuery.toLowerCase()) ||
//           user['email']
//               .toLowerCase()
//               .contains(event.searchQuery.toLowerCase());

//       final matchesStatus = event.selectedStatus == 'All' ||
//           (event.selectedStatus == 'Active' && user['isBlocked'] == false) ||
//           (event.selectedStatus == 'Blocked' && user['isBlocked'] == true);

//       return matchesQuery && matchesStatus;
//     }).toList();

//     emit(UserListLoaded(users: filteredUsers));
//   }
// }







import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rideadmin/model/user_list_model.dart';
import 'package:rideadmin/repositories/user_service.dart';


part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserApiService userApiService;
  List<UserModel> allUsers = [];

  UserBloc(this.userApiService) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<BlockUnblockUserEvent>(_onBlockUnblockUserEvent);
    on<SearchFilterUsers>(_onSearchFilterUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await UserApiService.getAllUsers();
      allUsers = users;
      emit(UserListLoaded(users: users));
    } catch (e) {
      emit(UserError('Failed to load users'));
    }
  }

  Future<void> _onBlockUnblockUserEvent(
      BlockUnblockUserEvent event, Emitter<UserState> emit) async {
    try {
      await userApiService.blockUnblockUser(event.userId, event.isBlocked);
      add(FetchUsers()); // Refresh user list after action
      emit(UserActionSuccess(
        event.isBlocked ? 'User blocked successfully' : 'User unblocked successfully',
      ));
    } catch (e) {
      emit(UserError('Failed to block/unblock user'));
    }
  }

  void _onSearchFilterUsers(
      SearchFilterUsers event, Emitter<UserState> emit) {
    final filteredUsers = allUsers.where((user) {
      final matchesQuery = user.name
              .toLowerCase()
              .contains(event.searchQuery.toLowerCase()) ||
          user.email
              .toLowerCase()
              .contains(event.searchQuery.toLowerCase());

      final matchesStatus = event.selectedStatus == 'All' ||
          (event.selectedStatus == 'Active' && !user.isBlocked) ||
          (event.selectedStatus == 'Blocked' && user.isBlocked);

      return matchesQuery && matchesStatus;
    }).toList();

    emit(UserListLoaded(users: filteredUsers));
  }
}
