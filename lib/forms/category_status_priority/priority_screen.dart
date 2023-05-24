import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PriorityScreen extends StatelessWidget {

  const PriorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _PriorityScreen());
  }
}

// ignore: must_be_immutable
class _PriorityScreen extends StatefulWidget {

  const _PriorityScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<_PriorityScreen> createState() => __PriorityScreenState();
}

class __PriorityScreenState extends State<_PriorityScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Priority"),
      ),
    );
  }
}
