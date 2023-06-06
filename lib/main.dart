import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'forms/SignUp_SignIn/signin_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(SignInForm());
}