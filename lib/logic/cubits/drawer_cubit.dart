
// ignore: depend_on_referenced_packages
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../forms/category_status_priority/category_screen.dart';
import '../../forms/category_status_priority/priority_screen.dart';
import '../../forms/category_status_priority/status_screen.dart';
import '../../forms/dashboard_page/item.dart';
import '../../forms/edit_profile_change_password/change_password_screen.dart';
import '../../forms/edit_profile_change_password/edit_profile_screen.dart';
import '../../forms/note/note_screen.dart';

class DrawerCubit extends Cubit<int> {
  DrawerCubit() : super(0);

  final List<Widget> pages = [
    const Center(child: HomeScreen()),
    const Center(child: NoteScreen()),
    const Center(child: CategoryScreen()),
    const Center(child: PriorityScreen()),
    const Center(child: StatusScreen()),
    const Center(child: EditProfileScreen()),
    const Center(child: ChangePasswordScreen()),
  ];

  final List<String> titles = [
    "Note Management System",
    "Note Screen",
    "Category Screen",
    "Priority Screen",
    "Status Screen",
    "Edit Profile Screen",
    "Change Password Screen",
  ];

  Widget? currentPage = const HomeScreen();
  String? currentTitle = "Note Management System";

  void selectIndex(int index, BuildContext context) => {
    emit(index),
    currentPage = pages[index],
    currentTitle = titles[index],
    Navigator.pop(context)
  };

  String? getCurrentTitle() {
    return currentTitle;
  }

  Widget? getCurrentPages() {
    return currentPage;
  }
}