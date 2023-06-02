
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_management_system_api/forms/SignUp_SignIn/signin_screen.dart';
import 'package:note_management_system_api/logic/repositories/user_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/user_data.dart';
import '../../logic/cubits/drawer_cubit.dart';
import '../../logic/cubits/user_cubit.dart';
import '../../logic/states/user_state.dart';
import '../../ultilities/Constant.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ignore: must_be_immutable
class SignUpForm extends StatelessWidget {
  SignUpForm({Key? key}) : super(key: key);

  DrawerCubit drawerCubit = DrawerCubit();

  late bool isEnglish = false;

  Future<void> initLanguage() async {
    isEnglish = await drawerCubit.initLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: drawerCubit.initSharePreference(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          initLanguage();
          return MaterialApp(
            supportedLocales: const [
              Locale(Constant.KEY_ENGLISH),
              Locale(Constant.KEY_VIETNAMESE)
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            locale: isEnglish
                ? const Locale(Constant.KEY_VIETNAMESE)
                : const Locale(Constant.KEY_ENGLISH),
            home: BlocProvider(
              create: (_) => UserCubit(),
              child: const _MySignUpForm(),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
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

  void clearData(){
    _email.text = "";
    _password.text = "";
    _repassword.text = "";
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).app_name),
        ),
        body: BlocConsumer<UserCubit, UserState> (
          listener: (context, state){
            if (state is FailureUserState){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)));
            }
            if (state is SuccessSignUpUserState){
              clearData();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context).regis_successful)));
            }
          },
          builder: (context, state){
            if (state is LoadingUserState){
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is FailureUserState){
              return _buildSignUpForm();
            } else {
              return _buildSignUpForm();
            }
          },
        )

    );


  }

  Widget _buildSignUpForm(){
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
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
                          return AppLocalizations.of(context).please_email;
                        } else {
                          int result = UserRepository.checkValidEmail(_email.text);
                          switch (result){
                            case Constant.KEY_EMAIL_HAS_LENGTH_LESS_6_CHAR: {
                              return AppLocalizations.of(context).please_6c;
                            }
                            case Constant.KEY_EMAIL_HAS_LENGTH_GREATER_256_CHAR: {
                              return AppLocalizations.of(context).please_256c;
                            }
                            case Constant.KEY_EMAIL_MALFORMED: {
                              return AppLocalizations.of(context).invalid_email;
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
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).password,
                        prefixIcon: const Icon(Icons.key, color: Constant.PRIMARY_COLOR),
                        border: const OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r"\s")),
                      ],
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return AppLocalizations.of(context).please_password;
                        } else {
                          int result = UserRepository.checkValidPassword(_password.text);
                          switch (result){
                            case Constant.KEY_PASSWORD_LENGTH_INVALID: {
                              return AppLocalizations.of(context).please_password_6_to_32;
                            }
                            case Constant.KEY_PASSWORD_WITHOUT_CAPTCHA: {
                              return AppLocalizations.of(context).please_password_1_capital;
                            }
                            case Constant.KEY_PASSWORD_WITHOUT_NUMBERS: {
                              return AppLocalizations.of(context).please_password_1_number;
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
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).re_password,
                        prefixIcon: const Icon(Icons.key, color: Constant.PRIMARY_COLOR),
                        border: const OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r"\s")),
                      ],
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return AppLocalizations.of(context).please_re_password;
                        } else if (_password.text!=value){
                          return AppLocalizations.of(context).please_password_do_match;
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
                                User user = User(
                                    email: _email.text,
                                    password: _password.text,
                                    info: Info(
                                      firstName: " ",
                                      lastName: " ",
                                    )
                                );
                                context.read<UserCubit>().signUp(user);
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context).sign_up,
                              style: const TextStyle(
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
                                    return SignInForm();
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
                            child: Text(
                              AppLocalizations.of(context).sign_in,
                              style: const TextStyle(
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
    );
  }
}
