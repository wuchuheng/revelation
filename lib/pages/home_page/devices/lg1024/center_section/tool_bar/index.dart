import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snotes/common/iconfont.dart';
import 'package:snotes/pages/common_config.dart';
import 'package:snotes/pages/home_page/devices/lg1024/center_section/tool_bar/first_row_section/icon_container.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({Key? key}) : super(key: key);

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CommonConfig.centerSectionToolBarHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: CommonConfig.borderColor),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          IconContainer(iconData: IconFont.icon_sort),
          Text("All"),
          IconContainer(iconData: IconFont.icon_notes),
        ],
      ),
    );
  }
}
