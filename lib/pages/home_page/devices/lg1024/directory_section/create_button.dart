import 'package:flutter/material.dart';
import 'package:snotes/common/iconfont.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/service/directory_service/index.dart';

class CreateButton extends StatelessWidget {
  final double bottomBarHeight;

  const CreateButton({Key? key, required this.bottomBarHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: DirectoryService.create,
      child: SizedBox(
        height: bottomBarHeight,
        width: double.infinity,
        child: Row(
          children: [
            Icon(IconFont.icon_plus, size: 13, color: Config.textGrey),
            Text(
              ' New Folder',
              style: TextStyle(color: Config.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
