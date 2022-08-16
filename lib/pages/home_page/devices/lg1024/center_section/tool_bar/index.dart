import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snotes/common/iconfont.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/pages/home_page/devices/lg1024/center_section/tool_bar/first_row_section/icon_container.dart';
import 'package:snotes/service/directory_service/index.dart';
import 'package:snotes/utils/subscription_builder/subscription_builder_abstract.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({Key? key}) : super(key: key);

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  Color? color;
  String title = DirectoryService.activeNodeHook.value?.title ?? '';
  final unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    super.initState();
    unsubscribeCollect.addAll([
      DirectoryService.activeNodeHook.subscribe((data) {
        if (data != null && data.title != title) setState(() => title = data.title);
      }),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    unsubscribeCollect.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Config.centerSectionToolBarHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Config.borderColor),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const IconContainer(iconData: IconFont.icon_sort),
          Text(title),
          const IconContainer(iconData: IconFont.icon_notes),
        ],
      ),
    );
  }
}
