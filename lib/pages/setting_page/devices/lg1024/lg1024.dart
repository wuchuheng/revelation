import 'package:flutter/material.dart';
import 'package:revelation/service/setting_service/setting_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import 'tab_section/tab_section.dart';

class LG1024SettingPage extends StatefulWidget {
  const LG1024SettingPage({Key? key}) : super(key: key);

  @override
  State<LG1024SettingPage> createState() => _LG1024SettingPageState();
}

class _LG1024SettingPageState extends State<LG1024SettingPage> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      SettingService.activeIndexHook.subscribe((value) => setState(() {})),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabSection(
        tabs: SettingService.tabs,
        activeIndex: SettingService.activeIndexHook.value,
        onChange: (index) => SettingService.setActiveIndex(index),
      ),
    );
  }
}
