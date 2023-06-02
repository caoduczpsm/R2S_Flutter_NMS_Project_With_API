
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_management_system_api/forms/SignUp_SignIn/signup_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_api/logic/cubits/drawer_cubit.dart';
import 'package:note_management_system_api/logic/cubits/user_cubit.dart';
import '../../data/user_data.dart';
import '../../logic/repositories/user_repository.dart';
import '../../logic/states/user_state.dart';
import '../../ultilities/Constant.dart';
import '../dashboard_page/dashboard.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ignore: must_be_immutable
class SignInForm extends StatelessWidget {

  SignInForm({Key? key}) : super(key: key);

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
              child: const _MySignInForm(),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class _MySignInForm extends StatefulWidget {
  const _MySignInForm({Key? key}) : super(key: key);

  @override
  State<_MySignInForm> createState() => _MySignInFormState();
}

class _MySignInFormState extends State<_MySignInForm> {

  final _signInForm = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final userCubit = UserCubit();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isGmail = false;
  bool _isRemember = false;
  String photoUrl = "";
  late SharedPreferences loginData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRemember();
  }

  @override
  void dispose(){
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  void checkRemember() async{
    loginData = await SharedPreferences.getInstance();
    bool? isRemember = (loginData.getBool(Constant.KEY_IS_REMEMBER));

    if (isRemember == true){
      moveToMain();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).app_name),
      ),
      body:  BlocConsumer<UserCubit, UserState> (
        listener: (context, state){
          if (state is FailureUserState){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state){
          bool isLoading = true;
          if (state is SuccessSignInUserState){
            User user = state.user;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              isLoading = false;
                if (_isGmail == true){
                  loginData.setBool(Constant.KEY_IS_GMAIL, true);
                } else {
                  loginData.setBool(Constant.KEY_IS_GMAIL, false);
                }
                if (_isRemember == true){
                  loginData.setBool(Constant.KEY_IS_REMEMBER, true);
                } else {
                  loginData.setBool(Constant.KEY_IS_REMEMBER, false);
                }
                loginData.setString(Constant.KEY_EMAIL, user.email);
                loginData.setString(Constant.KEY_PASSWORD, user.password);
                Info? userInfo = user.info;
                loginData.setString(Constant.KEY_FIRST_NAME, userInfo!.firstName);
                loginData.setString(Constant.KEY_LAST_NAME, userInfo.lastName);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteApp(),
                ),
              );
            });
            if (isLoading == true) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else if (state is LoadingUserState){
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FailureUserState){
            return _buildSignInForm();
          } else {
            return _buildSignInForm();
          }
          return Center(
            child: Text(state.toString()),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return SignUpForm();
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
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }



  Widget _buildSignInForm(){
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Image.asset('images/logo_login.png'),
            Form(
              key: _signInForm,
              child: Column(
                children: [
                  SizedBox(
                    width: size.width * 0.8,
                    child: TextFormField(
                      decoration:  const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Constant.PRIMARY_COLOR,),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value){
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
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: size.width * 0.8,
                    child: TextFormField(
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
                        }
                        return null;
                      },
                      controller: _password,
                      obscureText: true,
                    ),
                  ),

                  SizedBox(
                    width: size.width * 0.9,
                    child: CheckboxListTile(
                      title: Transform.translate (
                        offset: const Offset (200, 0),
                        child: Text(AppLocalizations.of(context).remember_me),
                      ),
                      value: _isRemember,
                      onChanged: (value) {
                        setState(() {
                          _isRemember = value!;
                        });
                      },
                    ),
                  ),

                  SizedBox(
                    width: size.width * 0.8,
                    height: size.height * 0.06,
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
                        if (_signInForm.currentState!.validate()){
                          User user = User(
                            email: _email.text,
                            password: _password.text,);
                          context.read<UserCubit>().signIn(user);

                        }
                      },
                      child: Text(
                        AppLocalizations.of(context).login,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Text(AppLocalizations.of(context).or_login_with,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),),
                  const SizedBox(height: 10,),
                  GoogleAuthButton(
                    text: AppLocalizations.of(context).login_google,
                    onPressed: () {
                      _googleSignIn.signIn().then((value){
                        _isGmail = true;
                        String displayName = value?.displayName ?? "";
                        List<String> nameParts = displayName.split(" ");

                        String firstName = nameParts.last;
                        String lastName = nameParts.sublist(0, nameParts.length - 1).join(" ");

                        Info userInfo = Info(
                          firstName: firstName,
                          lastName: lastName,
                        );

                        User user = User(
                          email: value!.email,
                          password: UserCubit.hashPassword(" "),
                          info: userInfo,
                        );
                        loginData.setString(Constant.KEY_PHOTO_URL, value.photoUrl!);
                        context.read<UserCubit>().signInWithGmail(user);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)));
  }

  void moveToMain(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  NoteApp(),
        ),
      );
    });
  }
}
