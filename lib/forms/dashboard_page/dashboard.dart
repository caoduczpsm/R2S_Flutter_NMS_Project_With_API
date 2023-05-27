import 'package:flutter/material.dart';
import '../../data/user_data.dart';
import '../../logic/cubits/drawer_cubit.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteApp extends StatelessWidget {
  final User user;
  const NoteApp({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: BlocProvider(
        create: (drawerContext) => DrawerCubit(),
        child: BlocBuilder<DrawerCubit, int>(
          builder: (cubitContext, state) {
            return Scaffold(
              appBar: AppBar(
                title:
                Text(cubitContext.read<DrawerCubit>().getCurrentTitle()!),
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
                                fit: BoxFit.contain),
                          ),
                          const Text('Group 1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              )),
                           Text(user.email,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text('Home'),
                      leading: const Icon(Icons.home),
                      onTap: () {
                        cubitContext
                            .read<DrawerCubit>()
                            .selectIndex(0, cubitContext);
                      },
                    ),
                    ListTile(
                      title: const Text('Note'),
                      leading: const Icon(Icons.note),
                      onTap: () {
                        cubitContext
                            .read<DrawerCubit>()
                            .selectIndex(1, cubitContext);
                      },
                    ),
                    ListTile(
                      title: const Text('Category'),
                      leading: const Icon(Icons.category),
                      onTap: () {
                        cubitContext
                            .read<DrawerCubit>()
                            .selectIndex(2, cubitContext);
                      },
                    ),
                    ListTile(
                      title: const Text('Priority'),
                      leading: const Icon(Icons.low_priority),
                      onTap: () {
                        cubitContext
                            .read<DrawerCubit>()
                            .selectIndex(3, cubitContext);
                      },
                    ),
                    ListTile(
                      title: const Text('Status'),
                      leading: const Icon(Icons.signal_wifi_statusbar_4_bar),
                      onTap: () {
                        cubitContext
                            .read<DrawerCubit>()
                            .selectIndex(4, cubitContext);
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
                        cubitContext
                            .read<DrawerCubit>()
                            .selectIndex(5, cubitContext);
                      },
                    ),
                    ListTile(
                      title: const Text('Change Password'),
                      leading: const Icon(Icons.password),
                      onTap: () {
                        cubitContext
                            .read<DrawerCubit>()
                            .selectIndex(6, cubitContext);
                      },
                    ),
                  ],
                ),
              ),
              body: cubitContext.read<DrawerCubit>().getCurrentPages(),
            );
          },
        ),
      ),
    );
  }
}
