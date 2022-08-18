import 'package:flutter/cupertino.dart';
import 'package:snotes/utils/logger.dart';

import '../../../../../../../common/iconfont.dart';

class DirectIconSection extends StatelessWidget {
  final bool isOpenFolder;
  final bool isNotEmpty;
  final void Function() onTap;
  const DirectIconSection({
    Key? key,
    required this.isOpenFolder,
    required this.onTap,
    required this.isNotEmpty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info(message: 'Build widget DirectIconSection', symbol: 'build');
    return GestureDetector(
      // onTap: () => setState(() => isOpenFold = !isOpenFold),
      onTap: onTap,
      child: Container(
          width: 20,
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: isNotEmpty
              ? Icon(
                  isOpenFolder ? IconFont.icon_bottom : IconFont.icon_right,
                  size: 13,
                )
              : null),
    );
  }
}
