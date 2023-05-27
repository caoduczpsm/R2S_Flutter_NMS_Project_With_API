

import '../../data/user_data.dart';

abstract class UserState{}

class InitialUserState extends UserState{}

class LoadingUserState extends UserState{}

class FailureUserState extends UserState{
  final String errorMessage;
  FailureUserState(this.errorMessage);
}

class SuccessSignInUserState extends UserState {
  final User user;
  SuccessSignInUserState(this.user);
}

class SuccessSignUpUserState extends UserState {
  final User user;
  SuccessSignUpUserState(this.user);
}

