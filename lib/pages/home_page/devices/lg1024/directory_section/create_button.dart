import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:snotes/common/iconfont.dart';
import 'package:snotes/pages/common_config.dart';
import 'package:snotes/service/imap_service.dart';
import 'package:snotes/service/note_service.dart';

class CreateButton extends StatelessWidget {
  final double bottomBarHeight;
  const CreateButton({Key? key, required this.bottomBarHeight})
      : super(key: key);

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert!!"),
          content: Text("You are awesome!"),
          actions: [
            MaterialButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void handleSelect(int value, BuildContext context) {
    // if value 1 show dialog
    if (value == 1) {
      _showDialog(context);
      // if value 2 show dialog
    } else if (value == 2) {
      _showDialog(context);
    }
  }

  List<PopupMenuItem<int>> getPopupMenuItem(BuildContext context) {
    const double fontSize = 17.0;
    return [
      PopupMenuItem(
        value: 1,
        // row with 2 children
        child: Row(
          children: const [
            Icon(IconFont.icon_file_directory, size: fontSize),
            SizedBox(width: 5),
            Text("Folder", style: TextStyle(fontSize: fontSize))
          ],
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: Row(
          children: const [
            Icon(IconFont.icon_setting, size: fontSize),
            SizedBox(width: 5),
            Text("Smart Folder", style: TextStyle(fontSize: fontSize))
          ],
        ),
      )
    ];
  }

  void testImap() async {
    await NoteService().createFold('hello');
  }

  Widget getLabel() {
    return Row(
      children: [
        Icon(IconFont.icon_plus, size: 13, color: CommonConfig.textGrey),
        Text(
          ' New Folder',
          style: TextStyle(color: CommonConfig.textGrey),
        ),
        ElevatedButton(
          onPressed: testImap,
          child: Text('tmp'),
        )
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
      child: PopupMenuButton<int>(
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
