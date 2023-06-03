import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_api/logic/repositories/user_repository.dart';
import 'package:note_management_system_api/logic/states/user_state.dart';
import 'package:crypto/crypto.dart';
import '../../data/user_data.dart';
import '../../ultilities/Constant.dart';

class UserCubit extends Cubit<UserState> {
  User? user;

  UserCubit() : super(InitialUserState());

  static String hashPassword(String password){
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signIn(User user) async {
    emit(LoadingUserState());
    try {
      var result = await UserRepository.signIn(user);
      if (result.status == Constant.KEY_STATUS_SIGNIN_SUCCESS){
        user.info = result.info!;
        emit(SuccessSignInUserState(user));
      } else {
        emit(FailureUserState("Invalid email or password"));
      }
    } catch (e){
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> signInWithGmail(User user) async{
    emit(LoadingUserState());
    try {
      var result = await UserRepository.signIn(user);
      if (result.status == Constant.KEY_STATUS_SIGNIN_HASERROR
          && result.error == Constant.KEY_STATUS_SIGNIN_NOTFOUND) {
        var singUp = await UserRepository.signUp(user);
        if (singUp.status == Constant.KEY_STATUS_SIGNUP_SUCCESS){
          emit(SuccessSignUpUserState(user));
        } else {
          emit(FailureUserState("Something went wrong!"));
        }
      } else {
        emit(SuccessSignInUserState(user));
      }
    } catch (e) {
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

  Future<void> editProfile(User user, String newEmail) async {
    emit(LoadingUserState());

    try {
      var result = await UserRepository.editProfile(user, newEmail);
      if (result.status == Constant.KEY_STATUS_1){
        user.email = newEmail;
        user.info = result.info;
        emit(SuccessEditProfileState(user));
      } else
        if (result.status == Constant.KEY_STATUS__1 && result.error == Constant.KEY_ERROR_2){
          emit(FailureUserState('Email Already Used!'));
        } else {
          emit(FailureUserState('Edit Successfully'));
        }
    } catch (e){
      emit(FailureUserState(e.toString()));
    }
  }

  Future<void> changePassword(User user, String newPassword) async {
    emit(LoadingUserState());
    try {
      var result = await UserRepository.changePassword(user, newPassword);
      if (result.status == Constant.KEY_STATUS_1){
        user.password = newPassword;
        emit(SuccessChangePasswordState(user));
      } else if (result.status == Constant.KEY_STATUS__1) {
        emit(FailureUserState('Wrong Current Password'));
      }
    } catch (e) {
      emit(FailureUserState(e.toString()));
    }
  }
}