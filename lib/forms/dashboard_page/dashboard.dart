import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_management_system_api/forms/SignUp_SignIn/signin_screen.dart';
import 'package:note_management_system_api/ultilities/Constant.dart';
import '../../logic/cubits/drawer_cubit.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_switch/flutter_switch.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:restart_app/restart_app.dart';
import '../../logic/states/drawer_state.dart';
// ignore: depend_on_referenced_packages
import 'package:restart_app/restart_app.dart';

// ignore: must_be_immutable
class NoteApp extends StatelessWidget {
  NoteApp({super.key});

  static const Color iconColor = Colors.black;
  static const TextStyle textStyle =
  TextStyle(fontSize: 16, color: Colors.black);
  static const Color selectedColor = Color.fromARGB(255, 98, 205, 255);
  bool isEnglish = false;
  DrawerCubit drawerCubit = DrawerCubit();
  String? email;
  String? firstName = "";
  String? lastName = "";
  String? fullName = "";
  bool? isGmail = false;
  String? currentTitle = "";
  late SharedPreferences preferences;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void initInfo(SharedPreferences preferences) {
    isEnglish = drawerCubit.initLanguage(preferences);
    firstName = drawerCubit.getFirstName(preferences);
    lastName = drawerCubit.getLastName(preferences);
    isGmail = drawerCubit.getIsGmail(preferences);
    fullName = drawerCubit.getFullName(preferences);
    email = drawerCubit.getEmail(preferences);
    currentTitle = drawerCubit.getCurrentTitle();
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<SharedPreferences>(
        future: drawerCubit.initSharePreference(),
        builder: (builderContext, snapshot) {
          if(snapshot.hasData) {
            preferences = snapshot.data!;
            initInfo(preferences);

            return  MaterialApp(
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
              home: BlocProvider.value(
                value: drawerCubit,
                child: BlocBuilder<DrawerCubit, DrawerState>(
                  builder: (cubitContext, state) {
                    return Scaffold(
                      appBar: AppBar(
                        title:
                        Text(cubitContext
                            .read<DrawerCubit>()
                            .getCurrentTitle()!),
                      ),
                      drawer: Drawer(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            DrawerHeader(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/drawer_background.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 90.0,
                                    height: 90.0,
                                    child: isGmail! ? _buildCircleAvatar() : _buildImageAsset(),
                                  ),
                                  Text(cubitContext
                                      .read<DrawerCubit>()
                                      .getFullName(preferences),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      )),
                                  Text("$email",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      )),
                                ],
                              ),
                            ),
                            ListTile(
                              title: Text(
                                AppLocalizations.of(cubitContext).home,
                                style: textStyle,
                              ),
                              leading: const Icon(
                                Icons.home,
                                color: iconColor,
                              ),
                              onTap: () {
                                cubitContext
                                    .read<DrawerCubit>()
                                    .selectIndex(0);
                                Navigator.pop(cubitContext);
                              },
                              selected: state.index == 0,
                              selectedTileColor: selectedColor,
                            ),
                            ListTile(
                              title: Text(AppLocalizations.of(cubitContext).note,
                                  style: textStyle),
                              leading: const Icon(
                                Icons.note,
                                color: iconColor,
                              ),
                              onTap: () {
                                cubitContext
                                    .read<DrawerCubit>()
                                    .selectIndex(1);
                                Navigator.pop(cubitContext);
                              },
                              selected: state.index == 1,
                              selectedTileColor: selectedColor,
                            ),
                            ListTile(
                              title: Text(AppLocalizations.of(cubitContext).category,
                                  style: textStyle),
                              leading: const Icon(Icons.category, color: iconColor),
                              onTap: () {
                                cubitContext
                                    .read<DrawerCubit>()
                                    .selectIndex(2);
                                Navigator.pop(cubitContext);
                              },
                              selected: state.index == 2,
                              selectedTileColor: selectedColor,
                            ),
                            ListTile(
                              title: Text(AppLocalizations.of(cubitContext).priority,
                                  style: textStyle),
                              leading: const Icon(Icons.low_priority, color: iconColor),
                              onTap: () {
                                cubitContext
                                    .read<DrawerCubit>()
                                    .selectIndex(3);
                                Navigator.pop(cubitContext);
                              },
                              selected: state.index == 3,
                              selectedTileColor: selectedColor,
                            ),
                            ListTile(
                              title: Text(AppLocalizations.of(cubitContext).status,
                                  style: textStyle),
                              leading: const Icon(Icons.signal_wifi_statusbar_4_bar,
                                  color: iconColor),
                              onTap: () {
                                cubitContext
                                    .read<DrawerCubit>()
                                    .selectIndex(4);
                                Navigator.pop(cubitContext);
                              },
                              selected: state.index == 4,
                              selectedTileColor: selectedColor,
                            ),
                            const Divider(),
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Text(AppLocalizations.of(cubitContext).account,
                                  style: textStyle),
                            ),
                            Visibility(
                              visible: !isGmail!,
                              child:  ListTile(
                                title: Text(
                                    AppLocalizations.of(cubitContext).edit_profile,
                                    style: textStyle),
                                leading: const Icon(
                                  Icons.account_box,
                                  color: iconColor,
                                ),
                                onTap: () {
                                  cubitContext
                                      .read<DrawerCubit>()
                                      .selectIndex(5);
                                  Navigator.pop(cubitContext);
                                },
                                selected: state.index == 5,
                                selectedTileColor: selectedColor,
                              ),
                            ),
                            Visibility(
                              visible: !isGmail!,
                              child:  ListTile(
                                title: Text(
                                    AppLocalizations.of(cubitContext).change_password,
                                    style: textStyle),
                                leading: const Icon(Icons.password, color: iconColor),
                                onTap: () {
                                  cubitContext
                                      .read<DrawerCubit>()
                                      .selectIndex(6);
                                  Navigator.pop(cubitContext);
                                },
                                selected: state.index == 6, // Thêm dòng này
                                selectedTileColor: selectedColor,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                  AppLocalizations.of(cubitContext).logout,
                                  style: textStyle),
                              leading: const Icon(Icons.logout, color: iconColor),
                              onTap: () {
                                preferences.setBool(Constant.KEY_IS_REMEMBER, false);
                                _googleSignIn.signOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInForm(),
                                  ),
                                );
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    child: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter stateSetter) {
                                        return FlutterSwitch(
                                            width: 50,
                                            height: 25,
                                            valueFontSize: 18,
                                            toggleSize: 20,
                                            value: preferences.getString(Constant.KEY_LANGUAGE) == Constant.KEY_VIETNAMESE? true : false,
                                            borderRadius: 30,
                                            padding: 4,
                                            showOnOff: false,
                                            activeColor: Colors.redAccent,
                                            inactiveColor: Colors.blueAccent,
                                            onToggle: (val) {
                                              stateSetter(() {
                                                cubitContext
                                                    .read<DrawerCubit>()
                                                    .onSwitchListener(val);
                                                Restart.restartApp();
                                              });
                                            });
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      preferences.getString(Constant.KEY_LANGUAGE) == Constant.KEY_VIETNAMESE
                                          ? "Tiếng Việt"
                                          : "English",
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      body: cubitContext.read<DrawerCubit>().getCurrentPages(),
                    );
                  },
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
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

