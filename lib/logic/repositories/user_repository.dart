
import 'dart:convert';

import 'package:note_management_system_api/data/user_data.dart';
import 'package:note_management_system_api/logic/cubits/user_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ultilities/Constant.dart';
import 'package:http/http.dart' as http;
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

  static Future<UserData> signIn(User user) async {
    final uri = Uri.parse('${Constant.KEY_BASE_URL}/login/?email=${user.email}&pass=${UserCubit.hashPassword(user.password!)}');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return UserData.fromJson(responseBody);
    } else {
      throw Exception('Failed to Sign In');
    }
  }

  static Future<UserData> signUp(User user) async {
    Info? info = user.info;
    final uri = Uri.parse(
        '${Constant.KEY_BASE_URL}/signup?email=${user.email}&pass=${UserCubit.hashPassword(user.password!)}&firstname=${info?.firstName}&lastname=${info?.lastName}');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return UserData.fromJson(responseBody);
    } else {
      throw Exception('Failed to Sign Up');
    }
  }

  static Future<UserData> editProfile(User user, String newEmail) async {
    Info? info = user.info;

    final uri = Uri.parse('${Constant.KEY_BASE_URL}/update?tab=Profile&email=${user.email}'
        '&nemail=$newEmail&firstname=${info?.firstName}&lastname=${info?.lastName}'
    );

    final response = await http.get(uri);

    if (response.statusCode == 200){
      final responseBody = json.decode(response.body);
      return UserData.fromJson(responseBody);
    } else {
      throw Exception('Failed to Edit Profile');
    }
  }

  static Future<UserData> changePassword(User user, String newPass) async {

    final uri = Uri.parse('${Constant.KEY_BASE_URL}/update?tab=Profile&'
        'email=${user.email}&pass=${user.password}&npass=$newPass');

    final response = await http.get(uri);

    if (response.statusCode == 200){
      final responseBody = json.decode(response.body);
      return UserData.fromJson(responseBody);
    } else {
      throw Exception('Failed to Change Password');
    }
  }
}