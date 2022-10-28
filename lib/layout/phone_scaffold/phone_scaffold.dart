import 'package:flutter/material.dart';
import 'package:revelation/common/iconfont.dart';

import '../../routes/route_path.dart';

class PhoneScaffoldLayout extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget body;
  const PhoneScaffoldLayout({
    Key? key,
    required this.body,
    this.bottomNavigationBar,
    this.appBar,
    this.floatingActionButton,
  }) : super(key: key);

  void onTapSetting(BuildContext context) {
    Navigator.pop(context);
    pushSettingPage(context);
  }

  void onTapNotes(BuildContext context) {
    Navigator.pop(context);
    pushHomePage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: WillPopScope(
        child: body,
        onWillPop: () async => false,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Setting', style: TextStyle(fontSize: 22)),
              leading: const Icon(Icons.settings),
              onTap: () => onTapSetting(context),
            ),
            ListTile(
              title: const Text('Notes', style: TextStyle(fontSize: 22)),
              leading: const Icon(IconFont.icon_notes),
              onTap: () => onTapNotes(context),
            ),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
