import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StatusScreen extends StatelessWidget {

  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _StatusScreen());
  }
}

// ignore: must_be_immutable
class _StatusScreen extends StatefulWidget {

  const _StatusScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<_StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<_StatusScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Status"),
      ),
    );
  }
}
