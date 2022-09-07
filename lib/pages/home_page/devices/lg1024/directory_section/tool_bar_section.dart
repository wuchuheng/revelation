import 'package:flutter/material.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/routes/route_path.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../center_section/tool_bar/icon_container.dart';

class ToolBarSection extends StatelessWidget {
  const ToolBarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget ToolBarSection', symbol: 'build');
    return Container(
      padding: const EdgeInsets.all(8),
      width: Config.lg1024DirectoryWidth,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Config.borderColor),
          right: BorderSide(width: 1, color: Config.borderColor),
        ),
      ),
      height: Config.titleBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconContainer(
            iconData: Icons.settings,
            onTap: () => RoutePath.pushSettingPage(),
          )
        ],
      ),
    );
  }
}
