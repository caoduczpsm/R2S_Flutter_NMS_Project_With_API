import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {

  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _EditProfileScreen());
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Edit Profile"),
      ),
    );
  }
}
