import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/user_data.dart';
import '../../logic/cubits/drawer_cubit.dart';
import '../../logic/cubits/user_cubit.dart';
import '../../logic/repositories/user_repository.dart';
import '../../logic/states/user_state.dart';
import '../../ultilities/Constant.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {

  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (_) => UserCubit(),
        child: const _EditProfileScreen(),
      );

  }
}

// ignore: must_be_immutable
class _EditProfileScreen extends StatefulWidget {

  const _EditProfileScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<_EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<_EditProfileScreen> {

  DrawerCubit drawerCubit = DrawerCubit();
  late SharedPreferences preferences;

  final _editProfileForm = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  late String currentEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  void getData(SharedPreferences preferences) async {
    _firstName.text = (drawerCubit.getFirstName(preferences))!;
    _lastName.text = (drawerCubit.getLastName(preferences))! ;
    _email.text = (drawerCubit.getEmail(preferences))! ;
    currentEmail = _email.text;
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
              body: BlocConsumer<UserCubit, UserState> (
                  listener: (context, state){
                    if (state is FailureUserState){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)));
                    } else if (state is SuccessEditProfileState){
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit Successfully')));
                    }
                  },
                  builder: (context, state){
                    if (state is SuccessEditProfileState){
                      preferences.setString(Constant.KEY_EMAIL, _email.text);
                      preferences.setString(Constant.KEY_FIRST_NAME, _firstName.text);
                      preferences.setString(Constant.KEY_LAST_NAME, _lastName.text);
                      getData(preferences);
                      return _editProfile();
                    }
                    else if (state is LoadingUserState){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return _editProfile();
                  }
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


  Widget _editProfile(){
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        const Center(
          child: Text('Edit Profile'
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
          key: _editProfileForm,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.drive_file_rename_outline, color: Constant.PRIMARY_COLOR,),
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z\s]'),
                  ),
                ],
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Please enter First Name';
                  } else {
                    int result = UserRepository.checkValidName(_firstName.text);
                    switch (result){
                      case Constant.KEY_EMAIL_HAS_LENGTH_LESS_6_CHAR: {
                        return 'First Name has a length of 2 - 32 characters';
                      }
                      case Constant.KEY_EMAIL_HAS_LENGTH_GREATER_256_CHAR: {
                        return 'Please do not end with a space';
                      }
                    }
                  }
                  return null;
                },
                controller: _firstName,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.drive_file_rename_outline, color: Constant.PRIMARY_COLOR,),
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z\s]'),
                  ),
                ],
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Please enter Last Name';
                  } else {
                    int result = UserRepository.checkValidName(_lastName.text);
                    switch (result){
                      case Constant.KEY_EMAIL_HAS_LENGTH_LESS_6_CHAR: {
                        return 'First Name has a length of 2 - 32 characters';
                      }
                      case Constant.KEY_EMAIL_HAS_LENGTH_GREATER_256_CHAR: {
                        return 'Please do not end with a space';
                      }
                    }
                  }
                  return null;
                },
                controller: _lastName,
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
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
                      case 1: {
                        return 'Please enter at least 6 characters';
                      }
                      case 2: {
                        return 'Please enter up to 256 characters';
                      }
                      case 3: {
                        return 'Invalid Email';
                      }
                    }
                  }
                  return null;
                },
                controller: _email,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:() async {
                      if (_editProfileForm.currentState!.validate())
                      {
                        String newEmail = _email.text;
                        Info info = Info(
                          firstName: _firstName.text,
                          lastName: _lastName.text,
                        );
                        User user = User(
                          email: currentEmail,
                          info: info,
                        );
                        context.read<UserCubit>().editProfile(user, newEmail);


                        // userController.editProfile(user.id!, _email.text,
                        //     _firstName.text, _lastName.text);
                        //
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(content: Text('Change Successful!')));
                        //
                        // setState(() {
                        //   user.email = _email.text;
                        //   user.firstName = _firstName.text;
                        //   user.lastName = _lastName.text;
                        //
                        // });
                      }
                    },
                    child: const Text('Change'),
                  ),
                  ElevatedButton(
                    onPressed:(){

                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context)
                      // => NoteApp()));

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
