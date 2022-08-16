import 'package:flutter/material.dart';
import 'package:snotes/pages/home_page/devices/lg1024/center_section/index.dart';
import 'package:snotes/pages/home_page/devices/lg1024/directory_section/index.dart';
import 'package:snotes/pages/home_page/devices/lg1024/edit_section/index.dart';

import 'float_buttons_section/index.dart';

class LG1024HomePage extends StatefulWidget {
  const LG1024HomePage({Key? key}) : super(key: key);

  @override
  State<LG1024HomePage> createState() => _LG1024HomePageState();
}

class _LG1024HomePageState extends State<LG1024HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          TreeSection(),
          CenterSection(),
          EditSection(),
        ],
      ),
      floatingActionButton: const FloatButtonSection(),
    );
  }
}
