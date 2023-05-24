import 'package:flutter/material.dart';
import 'package:note_management_system_api/logic/cubits/drawer_cubit.dart';

import '../category_status_priority/category_screen.dart';
import '../category_status_priority/priority_screen.dart';
import '../category_status_priority/status_screen.dart';
import '../edit_profile_change_password/change_password_screen.dart';
import '../edit_profile_change_password/edit_profile_screen.dart';
import '../note/note_screen.dart';
import 'item.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class NoteManagementApp extends StatelessWidget {

  const NoteManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyNoteManagementApp(),
    );
  }
}

// ignore: must_be_immutable
class MyNoteManagementApp extends StatefulWidget {

  const MyNoteManagementApp({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<MyNoteManagementApp> createState() => _MyNoteManagementAppState();
}

class _MyNoteManagementAppState extends State<MyNoteManagementApp> {

  String? _currentTitle;

  final mainImage = Image.asset(
    'images/drawer_background.jpg',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentTitle = 'Note Management System';
  }

  final List<Widget> pages = [
    const Center(child: HomeScreen()),
    const Center(child: NoteScreen()),
    const Center(child: CategoryScreen()),
    const Center(child: PriorityScreen()),
    const Center(child: StatusScreen()),
    const Center(child: EditProfileScreen()),
    const Center(child: ChangePasswordScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawerCubit(),
      child: BlocBuilder<DrawerCubit, int>(
        builder: (context, state) {

          return Scaffold(
            appBar: AppBar(
              title: Text(_currentTitle!),
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
                          child: Image.asset('images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Text('Group 1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        const Text("test@gmail.com",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('Home'),
                    leading: const Icon(Icons.home),
                    onTap: () {
                      setState(() {
                        context.read<DrawerCubit>().selectIndex(0);
                        _currentTitle = "Note Management System";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Note'),
                    leading: const Icon(Icons.note),
                    onTap: () {
                      setState(() {
                        context.read<DrawerCubit>().selectIndex(1);
                        _currentTitle = "Note";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Category'),
                    leading: const Icon(Icons.category),
                    onTap: () {
                      setState(() {
                        context.read<DrawerCubit>().selectIndex(2);
                        _currentTitle = "Category";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Priority'),
                    leading: const Icon(Icons.low_priority),
                    onTap: () {
                      setState(() {
                        context.read<DrawerCubit>().selectIndex(3);
                        _currentTitle = "Priority";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Status'),
                    leading: const Icon(Icons.signal_wifi_statusbar_4_bar),
                    onTap: () {
                      setState(() {
                        context.read<DrawerCubit>().selectIndex(4);
                        _currentTitle = "Status";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text("Account"),
                  ),
                  ListTile(
                    title: const Text('Edit Profile'),
                    leading: const Icon(Icons.account_box),
                    onTap: () {
                      setState(() {
                        context.read<DrawerCubit>().selectIndex(5);
                        _currentTitle = "Edit Profile";
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Change Password'),
                    leading: const Icon(Icons.password),
                    onTap: () {
                      setState(() {
                        context.read<DrawerCubit>().selectIndex(6);
                        _currentTitle = "Change Password";
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            body: pages[state],
          );
        },
      ),
    );
  }
}