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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../dashboard_page/dashboard.dart';

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
  late String fullName;
  bool? isGmail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  void getData(SharedPreferences preferences) async {
    _firstName.text = (drawerCubit.getFirstName(preferences))!;
    _lastName.text = (drawerCubit.getLastName(preferences))! ;
    fullName = (drawerCubit.getFullName(preferences));
    isGmail = drawerCubit.getIsGmail(preferences);
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
                          SnackBar(content: Text(AppLocalizations.of(context).edit_success)));
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
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Center(
          child: Text(AppLocalizations.of(context).edit_profile
            ,style: const TextStyle(
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).first_name,
                  prefixIcon: const Icon(Icons.drive_file_rename_outline, color: Constant.PRIMARY_COLOR,),
                  border: const OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z\s]'),
                  ),
                ],
                validator: (value){
                  if (value == null || value.isEmpty){
                    return AppLocalizations.of(context).please_enter_first_name;
                  } else {
                    int result = UserRepository.checkValidName(_firstName.text);
                    switch (result){
                      case Constant.KEY_EMAIL_HAS_LENGTH_LESS_6_CHAR: {
                        return AppLocalizations.of(context).error_first_name_32c;
                      }
                      case Constant.KEY_EMAIL_HAS_LENGTH_GREATER_256_CHAR: {
                        return AppLocalizations.of(context).error_name_space;
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).last_name,
                  prefixIcon: const Icon(Icons.drive_file_rename_outline, color: Constant.PRIMARY_COLOR,),
                  border: const OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z\s]'),
                  ),
                ],
                validator: (value){
                  if (value == null || value.isEmpty){
                    return AppLocalizations.of(context).please_enter_last_name;
                  } else {
                    int result = UserRepository.checkValidName(_lastName.text);
                    switch (result){
                      case Constant.KEY_EMAIL_HAS_LENGTH_LESS_6_CHAR: {
                        return AppLocalizations.of(context).error_last_name_32c;
                      }
                      case Constant.KEY_EMAIL_HAS_LENGTH_GREATER_256_CHAR: {
                        return AppLocalizations.of(context).error_name_space;
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
                enabled: false,
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
                      case 1: {
                        return AppLocalizations.of(context).please_6c;
                      }
                      case 2: {
                        return AppLocalizations.of(context).please_256c;
                      }
                      case 3: {
                        return AppLocalizations.of(context).invalid_email;
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
                  SizedBox(
                    width: size.width * 0.3,
                    height: size.height * 0.05,
                    child:  ElevatedButton(
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

                        }
                      },
                      child: Text(AppLocalizations.of(context).change),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.3,
                    height: size.height * 0.05,
                    child: ElevatedButton(
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
                      onPressed:(){
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context)
                        => NoteApp()));
                      },
                      child: Text(AppLocalizations.of(context).home),
                    ),
                  ),

                ],
              )
            ],
          ),
        ),

      ],
    );
  }

  Widget _buildCircleAvatar() {
    return CircleAvatar(
      backgroundImage: NetworkImage(preferences.getString(Constant.KEY_PHOTO_URL)!),
      radius: 45,
    );
  }

  Widget _buildImageAsset() {
    return SizedBox(
      width: 90.0,
      height: 90.0,
      child: Image.asset('images/logo.png', fit: BoxFit.contain),
    );
  }
}
