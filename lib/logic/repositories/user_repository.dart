
import '../../ultilities/Constant.dart';

class UserRepository {

  static int checkValidEmail(String email){
    if (email.length < 6) {
      return Constant.KEY_EMAIL_HAS_LENGTH_LESS_6_CHAR;
    } else
    if (email.length > 256){
      return Constant.KEY_EMAIL_HAS_LENGTH_GREATER_256_CHAR;
    }
    else
    if (RegExp(r'^(?!.*\.{2})[a-zA-Z0-9._]+(?<!\.)@[a-zA-Z0-9.-]+(?<!\.{2})\.[a-zA-Z]{2,}$')
        .hasMatch(email) == false) {
      return Constant.KEY_EMAIL_MALFORMED;
    } else {
      return Constant.KEY_VALID_EMAIL;
    }
  }

  static int checkValidPassword(String password){
    if (password.length < 6 || password.length > 32){
      return Constant.KEY_PASSWORD_LENGTH_INVALID;
    } else
    if (RegExp(r'^(?=.*[A-Z]).+$')
        .hasMatch(password) == false) {
      return Constant.KEY_PASSWORD_WITHOUT_CAPTCHA;
    } else
    if (RegExp(r'^(?=.*\d).+$')
        .hasMatch(password) == false){
      return Constant.KEY_PASSWORD_WITHOUT_NUMBERS;
    } else {
      return Constant.KEY_PASSWORD_VALID;
    }
  }

  static int checkValidName(String name){
    if (name.length < 2 || name.length > 32){
      return Constant.KEY_NAME_LENGTH_INVALID;
    } else
    if (name[name.length-1] == " "){
      return Constant.KEY_NAME_WITH_FINAL_SPACE;
    } else {
      return Constant.KEY_NAME_VALID;
    }
  }
}