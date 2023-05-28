import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_api/logic/repositories/user_repository.dart';
import 'package:note_management_system_api/logic/states/user_state.dart';

import '../../data/user_data.dart';
import '../../ultilities/Constant.dart';

class UserCubit extends Cubit<UserState> {
  User? user;

  UserCubit() : super(InitialUserState());

  Future<void> signIn(User user) async {
    emit(LoadingUserState());
    try {
      var result = await UserRepository.signIn(user);
      if (result.status == Constant.KEY_STATUS_SIGNIN_SUCCESS){
        user.info = result.info;
        emit(SuccessSignInUserState(user));
      } else {
        emit(FailureUserState("Invalid email or password"));
      }
    } catch (e){
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> signUp(User user) async {
    emit(LoadingUserState());
    try {
      var result = await UserRepository.signUp(user);
      if (result.status == Constant.KEY_STATUS_SIGNUP_SUCCESS){
        emit(SuccessSignUpUserState(user));
      } else {
        emit(FailureUserState("Email Already Used"));
      }
    } catch (e){
      emit(FailureUserState(e.toString()));
    }
  }

}