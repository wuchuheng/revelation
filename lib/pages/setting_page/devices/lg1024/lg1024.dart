import 'package:flutter/material.dart';
import 'package:revelation/pages/setting_page/devices/widgets/float_buttons_section.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import 'tab_section/tab_section.dart';

class LG1024SettingPage extends StatefulWidget {
  final GlobalService globalService;
  const LG1024SettingPage({Key? key, required this.globalService}) : super(key: key);

  @override
  State<LG1024SettingPage> createState() => _LG1024SettingPageState();
}

class _LG1024SettingPageState extends State<LG1024SettingPage> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      widget.globalService.settingService.activeIndexHook.subscribe((value, _) => setState(() {})),
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
        tabs: widget.globalService.settingService.tabs,
        activeIndex: widget.globalService.settingService.activeIndexHook.value,
        onChange: (index) => widget.globalService.settingService.setActiveIndex(index),
      ),
      floatingActionButton: FloatButtonsSection(globalService: widget.globalService),
    );
  }
}
