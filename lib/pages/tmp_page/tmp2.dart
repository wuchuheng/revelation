import 'package:flutter/material.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

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
    Logger.info('Build widget Tmp2Page', symbol: 'build');
    return const Scaffold(
      body: Center(
        child: Text('loginPage'),
      ),
    );
  }
}
