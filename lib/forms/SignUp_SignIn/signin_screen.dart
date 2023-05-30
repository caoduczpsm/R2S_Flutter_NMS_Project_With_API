
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_management_system_api/forms/SignUp_SignIn/signup_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_api/logic/cubits/user_cubit.dart';
import '../../data/user_data.dart';
import '../../logic/repositories/user_repository.dart';
import '../../logic/states/user_state.dart';
import '../../ultilities/Constant.dart';
import '../dashboard_page/dashboard.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const SignInForm());

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => UserCubit(),
        child: const _MySignInForm(),
      ),
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
    bool? isRemember = (loginData.getBool('isRemember'));

    if (isRemember == true){
      moveToMain();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Management System'),
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
                  loginData.setBool('isGmail', true);
                } else {
                  loginData.setBool('isGmail', false);
                }
                if (_isRemember == true){
                  loginData.setBool("isRemember", true);
                } else {
                  loginData.setBool("isRemember", false);
                }
                loginData.setString('email', user.email);
                loginData.setString('password', user.password);
                Info? userInfo = user.info;
                loginData.setString('firstName', userInfo!.firstName);
                loginData.setString('lastName', userInfo.lastName);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  const NoteApp(),
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
                return const SignUpForm();
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
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: size.width * 0.8,
                    child: TextFormField(
                      decoration:  const InputDecoration(
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
                        }
                        return null;
                      },
                      controller: _password,
                      obscureText: true,
                    ),
                  ),

                  SizedBox(
                    width: size.width * 0.9,
                    child:CheckboxListTile(
                      title: const Text("                             "
                          "               Remember me"),
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
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text('_________________Or Login With_________________',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),),
                  const SizedBox(height: 10,),
                  GoogleAuthButton(
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
                        loginData.setString('photoUrl', value.photoUrl!);
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
          builder: (context) =>  const NoteApp(),
        ),
      );
    });
  }
}
