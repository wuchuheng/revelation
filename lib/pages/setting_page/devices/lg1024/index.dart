import 'package:flutter/material.dart';
import 'package:snotes/pages/setting_page/devices/lg1024/tab_section/header_section.dart';

import 'tab_section/index.dart';

class LG1024SettingPage extends StatefulWidget {
  const LG1024SettingPage({Key? key}) : super(key: key);

  @override
  State<LG1024SettingPage> createState() => _LG1024SettingPageState();
}

class _LG1024SettingPageState extends State<LG1024SettingPage> {
  List<TabItem> tabs = [
    TabItem(icon: Icons.settings, text: 'General'),
    TabItem(icon: Icons.people, text: 'User'),
    TabItem(icon: Icons.notes, text: 'Log'),
  ];
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabSection(
        tabs: tabs,
        activeIndex: activeIndex,
        onChange: (index) => setState(() => activeIndex = index),
      ),
    );
  }
}
