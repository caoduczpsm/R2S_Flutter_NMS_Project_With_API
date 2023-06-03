import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/user_data.dart';
import '../../logic/cubits/drawer_cubit.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import '../../logic/cubits/user_cubit.dart';
import '../../logic/repositories/user_repository.dart';
import '../../logic/states/user_state.dart';
import '../../ultilities/Constant.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ChangePasswordScreen extends StatelessWidget {

  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (_) => UserCubit(),
      child: const _ChangePasswordScreen(),
    );
  }
}

// ignore: must_be_immutable
class _ChangePasswordScreen extends StatefulWidget {

  const _ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<_ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<_ChangePasswordScreen> {

  DrawerCubit drawerCubit = DrawerCubit();
  late SharedPreferences preferences;

  final _changePasswordForm = GlobalKey<FormState>();
  final _currentPassword = TextEditingController();
  final _password = TextEditingController();
  final _repassword = TextEditingController();

  late String currentPassword;
  late String email;

  void getData(SharedPreferences preferences) async {
    currentPassword = (drawerCubit.getPassword(preferences));
    email = drawerCubit.getEmail(preferences)!;
  }

  void refreshData() {
    _currentPassword.text = "";
    _password.text = "";
    _repassword.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: drawerCubit.initSharePreference(),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            preferences = snapshot.data!;
            getData(preferences);
            return Scaffold(
                body: BlocConsumer<UserCubit, UserState>(
                listener: (context, state){
                  if (state is FailureUserState){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)));
                  } else if (state is SuccessChangePasswordState){
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Change Successfully')));
                  }
                },
                builder: (context, state) {
                  if (state is SuccessChangePasswordState){
                    User user = state.user;
                    preferences.setString(Constant.KEY_PASSWORD,user.password!);
                    getData(preferences);
                    refreshData();
                    return _changePassword();
                  }
                  else if (state is LoadingUserState){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return _changePassword();
                  },
                ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }

  Widget _changePassword(){
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        const Center(
          child: Text('Change Password'
            ,style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),),
        ),
        const SizedBox(
          height: 30,
        ),
        Form(
          key: _changePasswordForm,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.password, color: Constant.PRIMARY_COLOR,),
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Please enter password';
                  }
                  return null;
                },
                controller: _currentPassword,
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.key, color: Constant.PRIMARY_COLOR,),
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
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Re-Password',
                  prefixIcon: Icon(Icons.key, color: Constant.PRIMARY_COLOR,),
                  border: OutlineInputBorder(),
                ),
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
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:() async {
                      if (_changePasswordForm.currentState!.validate()){
                        String newPassword = UserCubit.hashPassword(_password.text);
                        User user = User(
                          email: email,
                          password: UserCubit.hashPassword(_currentPassword.text),
                        );

                        context.read<UserCubit>().changePassword(user, newPassword);

                        // if (user.password
                        //     == userController.hashPassword(_currentPassword.text.trim())) {
                        //
                        //   userController.changePassword(user.email!,
                        //       userController.hashPassword(_password.text.trim()));
                        //
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(content: Text('Change Successful!')));
                        //
                        //   setState(() {
                        //     user.password = userController.hashPassword(_password.text.trim());
                        //     _currentPassword.text = "";
                        //     _password.text = "";
                        //     _repassword.text = "";
                        //
                        //   });
                        //
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(content: Text('Current Password '
                        //           'Does Not Match!')));
                        // }
                        // //  }
                      }
                    },
                    child: const Text('Change'),
                  ),
                  ElevatedButton(
                    onPressed:(){
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context)
                      // => NoteManagementApp(user: user)));
                    },
                    child: const Text('Home'),
                  )
                ],
              )
            ],
          ),
        ),

      ],
    );
  }
}
