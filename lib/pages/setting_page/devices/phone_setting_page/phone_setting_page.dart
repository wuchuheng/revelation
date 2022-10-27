import 'package:flutter/material.dart';
import 'package:revelation/layout/phone_scaffold/phone_scaffold.dart';
import 'package:revelation/service/setting_service/setting_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import '../../../../config/config.dart';

class PhoneSettingPage extends StatefulWidget {
  const PhoneSettingPage({Key? key}) : super(key: key);

  @override
  State<PhoneSettingPage> createState() => _PhoneSettingPageState();
}

class _PhoneSettingPageState extends State<PhoneSettingPage> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  void onTapBottomNavigation(int index) {
    SettingService.setActiveIndex(index);
  }

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
    final activeItem = SettingService.tabs[SettingService.activeIndexHook.value];
    final navigationItemColor = Colors.black;
    final item = activeItem.body;

    return PhoneScaffoldLayout(
      appBar: AppBar(
        title: Text('Setting-${activeItem.text}'),
      ),
      body: item,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Config.borderColor)),
        ),
        height: 50,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          for (int index = 0; index < SettingService.tabs.length; index++)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTapBottomNavigation(index),
              child: Container(
                width: MediaQuery.of(context).size.width / SettingService.tabs.length,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      SettingService.tabs[index].icon,
                      color: SettingService.activeIndexHook.value == index ? Config.primaryColor : navigationItemColor,
                    ),
                    Text(
                      SettingService.tabs[index].text,
                      style: TextStyle(
                        color:
                            SettingService.activeIndexHook.value == index ? Config.primaryColor : navigationItemColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
