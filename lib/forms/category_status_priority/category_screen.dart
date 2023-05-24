import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatelessWidget {

  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _CategoryScreen());
  }
}

// ignore: must_be_immutable
class _CategoryScreen extends StatefulWidget {

  const _CategoryScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<_CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<_CategoryScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Category"),
      ),
    );
  }
}
