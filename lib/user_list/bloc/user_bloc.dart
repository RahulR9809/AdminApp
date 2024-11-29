import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rideadmin/controller/user_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserApiService userApiService;
  UserBloc(this.userApiService) : super(UserInitial()) {
    on<FetchUsers>(onfetchusers);
        on<BlockUnblockUserEvent>(onBlockUnblockUserEvent);

  }

  FutureOr<void> onfetchusers(FetchUsers event,
   Emitter<UserState> emit)async {
    emit(UserLoading());
    try{
        final users=await UserApiService.getAllusers();
        if(users.isNotEmpty){
        emit(UserListLoaded(users: users));

        }
    }catch(e){
      emit(UserError('failed to load drivers'));
    }
   }

   
 Future<void> onBlockUnblockUserEvent(
    BlockUnblockUserEvent event, Emitter<UserState> emit) async {
  try {
    await userApiService.blocunblockUser(event.userId, event.isBlocked);
    add(FetchUsers()); // Refresh the user list after the block/unblock action
    emit(UserActionSuccess(
       event.isBlocked ? 'User blocked successfully' : 'User unblocked successfully',
    ));
  } catch (e) {
    emit(UserError('Failed to block/unblock user'));
  }
}

}



