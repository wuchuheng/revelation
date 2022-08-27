import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../../../common/iconfont.dart';
import '../../../../../../../config/config.dart';

class FolderIconSection extends StatelessWidget {
  final bool isActive;
  const FolderIconSection({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget FolderIconSection', symbol: 'build');
    return Icon(
      IconFont.icon_file_directory,
      size: 17.5,
      color: Config.fontColor,
    );
  }
}
