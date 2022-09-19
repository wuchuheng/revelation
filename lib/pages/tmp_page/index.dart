import 'dart:async';

import 'package:flutter/material.dart' hide MenuItem;
import 'package:wuchuheng_ui/wuchuheng_ui.dart';

class TmpPage extends Page {
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
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          timer?.cancel();
          timer = Timer(
              const Duration(seconds: 1),
              () => {
                    onConfirmDialog(
                      onConfirm: (value) {
                        print(value);
                      },
                      validator: (String? value) {
                        if (value != null && value == '') {
                          return 'Node name is not empty.';
                        }
                        return null;
                      },
                      context: context,
                      title: 'create New Node',
                    ),
                  });
          return const Text('hello');
        },
      ),
    );
  }
}
