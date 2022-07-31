import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'routes/route_path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: RoutePath.getAppPathInstance().build(
      context,
      "stmpNotes",
      ThemeData(
        backgroundColor: HexColor("#FFFFFF"),
      ),
    ));
  }
}
