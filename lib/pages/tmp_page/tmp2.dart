import 'package:flutter/material.dart';

class Tmp2Page extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const Tmp();
      },
    );
  }
}

class Tmp extends StatefulWidget {
  const Tmp({Key? key}) : super(key: key);

  @override
  State<Tmp> createState() => _TmpState();
}

class _TmpState extends State<Tmp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('loginPage'),
      ),
    );
  }
}
