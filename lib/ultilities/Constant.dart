import 'dart:ui';

class Constant {

  // ignore: constant_identifier_names
  static const KEY_BASE_URL = "https://it-fresher.edu.vn/nms";

  // ignore: constant_identifier_names
  static const KEY_NOTE_READ_ALL = "$KEY_BASE_URL/get?tab=Note&email=";

  // ignore: constant_identifier_names
  static const KEY_CREATE_NOTE = "$KEY_BASE_URL/add?tab=Note&email=";

  // ignore: constant_identifier_names
  static const KEY_UPDATE_NOTE = "$KEY_BASE_URL/update?tab=Note&email=";

  // ignore: constant_identifier_names
  static const KEY_DELETE_NOTE = "$KEY_BASE_URL/del?tab=Note&email=";

  // ignore: constant_identifier_names
  static const KEY_CATEGORY_READ_ALL = "$KEY_BASE_URL/get?tab=Category&email=";

  // ignore: constant_identifier_names
  static const KEY_STATUS_READ_ALL = "$KEY_BASE_URL/get?tab=Status&email=";

  // ignore: constant_identifier_names
  static const KEY_PRIORITY_READ_ALL = "$KEY_BASE_URL/get?tab=Priority&email=";

  // ignore: constant_identifier_names
  static const PRIMARY_COLOR = Color(0XFF4CAEE3);

  // Đăng nhập đăng ký

  // ignore: constant_identifier_names
  static const KEY_STATUS_SIGNIN_SUCCESS = 1;
  // ignore: constant_identifier_names
  static const KEY_STATUS_SIGNUP_SUCCESS = 1;
  // ignore: constant_identifier_names
  static const KEY_STATUS_SIGNIN_NOTFOUND = 1;
  // ignore: constant_identifier_names
  static const KEY_STATUS_SIGNIN_HASERROR = -1;
  // ignore: constant_identifier_names
  static const KEY_EMAIL_HAS_LENGTH_LESS_6_CHAR  = 1;
  // ignore: constant_identifier_names
  static const KEY_EMAIL_HAS_LENGTH_GREATER_256_CHAR  = 2;
  // ignore: constant_identifier_names
  static const KEY_EMAIL_MALFORMED  = 3;
  // ignore: constant_identifier_names
  static const KEY_VALID_EMAIL  = 0;

  // ignore: constant_identifier_names
  static const KEY_PASSWORD_LENGTH_INVALID = 1;
  // ignore: constant_identifier_names
  static const KEY_PASSWORD_WITHOUT_CAPTCHA = 2;
  // ignore: constant_identifier_names
  static const KEY_PASSWORD_WITHOUT_NUMBERS = 3;
  // ignore: constant_identifier_names
  static const KEY_PASSWORD_VALID = 0;

  // Check Name
  // ignore: constant_identifier_names
  static const KEY_NAME_LENGTH_INVALID = 1;
  // ignore: constant_identifier_names
  static const KEY_NAME_WITH_FINAL_SPACE = 2;
  // ignore: constant_identifier_names
  static const KEY_NAME_VALID = 0;

  //Language
  // ignore: constant_identifier_names
  static const KEY_LANGUAGE = "language";
  // ignore: constant_identifier_names
  static const KEY_ENGLISH = "en";
  // ignore: constant_identifier_names
  static const KEY_VIETNAMESE = "vi";

  // ignore: constant_identifier_names
  static const KEY_STATUS_1 = 1;
  // ignore: constant_identifier_names
  static const KEY_STATUS__1 = -1;
  // ignore: constant_identifier_names
  static const KEY_ERROR_1 = 1;
  // ignore: constant_identifier_names
  static const KEY_ERROR_2 = 2;

  //Share Preference
  // ignore: constant_identifier_names
  static const KEY_EMAIL = "email";

  // ignore: constant_identifier_names
  static const KEY_PASSWORD = "password";

  // ignore: constant_identifier_names
  static const KEY_FIRST_NAME = "firstName";

  // ignore: constant_identifier_names
  static const KEY_LAST_NAME = "lastName";

  // ignore: constant_identifier_names
  static const KEY_IS_GMAIL = "isGmail";

  // ignore: constant_identifier_names
  static const KEY_IS_REMEMBER = "isRemember";

  // ignore: constant_identifier_names
  static const KEY_PHOTO_URL = "photoUrl";
}