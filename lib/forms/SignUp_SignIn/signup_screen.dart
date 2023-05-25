import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_management_system_api/forms/SignUp_SignIn/signin_screen.dart';
import 'package:note_management_system_api/logic/repositories/user_repository.dart';

import '../../ultilities/Constant.dart';
import 'Container.dart';

void main() => runApp(const SignUpForm());

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _MySignUpForm(),
    );
  }
}

class _MySignUpForm extends StatefulWidget {
  const _MySignUpForm({Key? key}) : super(key: key);

  @override
  State<_MySignUpForm> createState() => _MySignUpFormState();
}

class _MySignUpFormState extends State<_MySignUpForm> {


  final _signUpForm = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repassword = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    _email.dispose();
    _password.dispose();
    _repassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Note Management System'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset('images/logo_login.png'),

                Form(
                  key: _signUpForm,
                  child: Column(
                    children: [
                      SizedBox(
                        width: size.width * 0.8,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email, color: Constant.PRIMARY_COLOR,),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty){
                              return 'Please enter email';
                            } else {
                              int result = UserRepository.checkValidEmail(_email.text);
                              switch (result){
                                case Constant.KEY_EMAIL_HAS_LENGTH_LESS_6_CHAR: {
                                  return 'Please enter at least 6 characters';
                                }
                                case Constant.KEY_EMAIL_HAS_LENGTH_GREATER_256_CHAR: {
                                  return 'Please enter up to 256 characters';
                                }
                                case Constant.KEY_EMAIL_MALFORMED: {
                                  return 'Invalid Email';
                                }
                              }
                            }
                            return null;
                          },
                          controller: _email,
                        ),),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: size.width * 0.8,
                        child:  TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.key, color: Constant.PRIMARY_COLOR),
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r"\s")),
                          ],
                          validator: (value){
                            if (value == null || value.isEmpty){
                              return 'Please enter password';
                            } else {
                              int result = UserRepository.checkValidPassword(_password.text);
                              switch (result){
                                case Constant.KEY_PASSWORD_LENGTH_INVALID: {
                                  return 'Password length from 6 - 32 characters';
                                }
                                case Constant.KEY_PASSWORD_WITHOUT_CAPTCHA: {
                                  return 'Please enter at least 1 capital letter';
                                }
                                case Constant.KEY_PASSWORD_WITHOUT_NUMBERS: {
                                  return 'Please enter at least 1 number';
                                }
                              }
                            }
                            return null;
                          },
                          controller: _password,
                          obscureText: true,
                        ),),
                      const SizedBox(height: 10),
                      SizedBox(
                        width:  size.width * 0.8,
                        child:  TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Re-Password',
                            prefixIcon: Icon(Icons.key, color: Constant.PRIMARY_COLOR),
                            border: OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r"\s")),
                          ],
                          validator: (value){
                            if (value == null || value.isEmpty){
                              return 'Please enter re-password';
                            } else if (_password.text!=value){
                              return 'Password does not match!';
                            }
                            return null;
                          },
                          controller: _repassword,
                          obscureText: true,
                        ),),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: size.width * 0.8,
                        height: size.height * 0.06,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: size.width * 0.3,
                              height: size.height * 0.05,
                              child:ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(size.width * 0.5),
                                      side: BorderSide(
                                        width: size.width * 0.8,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed:() async {
                                  if (_signUpForm.currentState!.validate()){


                                  }
                                },
                                child: const Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.3,
                              height: size.height * 0.05,
                              child:ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(size.width * 0.5),
                                      side: BorderSide(
                                        width: size.width * 0.8,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed:() async {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return const SignInForm();
                                      },
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
        )

    );
  }
}
