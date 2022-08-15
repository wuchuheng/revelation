import 'package:flutter/material.dart';
import 'package:snotes/common/iconfont.dart';
import 'package:snotes/pages/common_config.dart';
import 'package:snotes/service/directory_service/index.dart';

class MenuItemData {
  final String name;
  final String value;

  MenuItemData({required this.name, required this.value});
}

class CreateButton extends StatelessWidget {
  final double bottomBarHeight;
  static String createFolderValue = 'Folder';

  List<MenuItemData> menuList = [
    MenuItemData(name: 'Folder', value: createFolderValue),
    MenuItemData(name: 'Smart Folder', value: 'Smart Folder'),
  ];

  CreateButton({Key? key, required this.bottomBarHeight}) : super(key: key);

  void handleSelect(String value, BuildContext context) async {
    if (value == createFolderValue) {
      await DirectoryTreeService.create();
      return;
    }
  }

  List<PopupMenuItem<String>> getPopupMenuItem(BuildContext context) {
    const double fontSize = 17.0;
    return menuList
        .map((e) => PopupMenuItem(
              value: e.value,
              child: Row(
                children: [
                  const Icon(IconFont.icon_setting, size: fontSize),
                  const SizedBox(width: 5),
                  Text(e.name, style: const TextStyle(fontSize: fontSize))
                ],
              ),
            ))
        .toList();
  }

  void testImap() async {}

  Widget getLabel() {
    return Row(
      children: [
        Icon(IconFont.icon_plus, size: 13, color: CommonConfig.textGrey),
        Text(
          ' New Folder',
          style: TextStyle(color: CommonConfig.textGrey),
        ),
      ],
    );
  }

  Widget getConTainer({required Widget child}) {
    return SizedBox(
      height: bottomBarHeight,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [child],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getConTainer(
      child: PopupMenuButton<String>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        itemBuilder: getPopupMenuItem,
        offset: const Offset(80, 100),
        elevation: 2,
        // on selected we show the dialog box
        onSelected: (value) => handleSelect(value, context),
        child: getLabel(),
      ),
    );
  }
}
