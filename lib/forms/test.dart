import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ignore: must_be_immutable
class TestScreen extends StatelessWidget {

  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      supportedLocales: [
        Locale('en'),
        Locale('vi')
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      locale: Locale('vi'),
      debugShowCheckedModeBanner: false,
      home: _TestScreen(),
    );
  }
}

// ignore: must_be_immutable
class _TestScreen extends StatefulWidget {

  const _TestScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<_TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<_TestScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(AppLocalizations.of(context).hello_world),
      ),
    );
  }
}
