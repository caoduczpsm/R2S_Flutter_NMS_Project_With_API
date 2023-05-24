import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChangePasswordScreen extends StatelessWidget {

  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _ChangePasswordScreen());
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Change Password"),
      ),
    );
  }
}
