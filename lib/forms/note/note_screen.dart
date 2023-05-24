import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoteScreen extends StatelessWidget {

  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _NoteScreen());
  }
}

// ignore: must_be_immutable
class _NoteScreen extends StatefulWidget {

  const _NoteScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<_NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<_NoteScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Note"),
      ),
    );
  }
}
