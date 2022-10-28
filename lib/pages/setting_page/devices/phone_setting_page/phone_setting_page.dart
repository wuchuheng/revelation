import 'package:flutter/material.dart';
import 'package:revelation/layout/phone_scaffold/phone_scaffold.dart';
import 'package:revelation/pages/setting_page/devices/widgets/float_buttons_section.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import '../../../../config/config.dart';

class PhoneSettingPage extends StatefulWidget {
  final GlobalService globalService;
  const PhoneSettingPage({Key? key, required this.globalService}) : super(key: key);

  @override
  State<PhoneSettingPage> createState() => _PhoneSettingPageState();
}

class _PhoneSettingPageState extends State<PhoneSettingPage> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  void onTapBottomNavigation(int index) {
    widget.globalService.settingService.setActiveIndex(index);
  }

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      widget.globalService.settingService.activeIndexHook.subscribe((value) => setState(() {})),
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
    final activeItem =
        widget.globalService.settingService.tabs[widget.globalService.settingService.activeIndexHook.value];
    const navigationItemColor = Colors.black;
    final item = activeItem(context).body;

    return PhoneScaffoldLayout(
      appBar: AppBar(title: Text('Setting-${activeItem(context).text}')),
      body: item,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Config.borderColor)),
        ),
        height: 50,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          for (int index = 0; index < widget.globalService.settingService.tabs.length; index++)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTapBottomNavigation(index),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / widget.globalService.settingService.tabs.length,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      widget.globalService.settingService.tabs[index](context).icon,
                      color: widget.globalService.settingService.activeIndexHook.value == index
                          ? Config.primaryColor
                          : navigationItemColor,
                    ),
                    Text(
                      widget.globalService.settingService.tabs[index](context).text,
                      style: TextStyle(
                        color: widget.globalService.settingService.activeIndexHook.value == index
                            ? Config.primaryColor
                            : navigationItemColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ]),
      ),
      floatingActionButton: FloatButtonsSection(globalService: widget.globalService),
    );
  }
}
