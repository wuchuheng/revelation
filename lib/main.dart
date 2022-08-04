import 'package:flutter/material.dart';
import 'package:snotes/routes/route_path.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     body: Column(
    //   children: [ElevatedButton(onPressed: () {}, child: Text('button'))],
    // ));
    return RoutePath.getAppPathInstance().build(
      context,
      'snote',
      ThemeData(),
    );
  }
}
