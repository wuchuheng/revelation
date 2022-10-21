import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revelation/common/iconfont.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/pages/home_page/devices/lg1024/center_section/tool_bar/icon_container.dart';
import 'package:revelation/service/cache_service.dart';
import 'package:revelation/service/directory_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../../service/chapter_service/index.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({Key? key}) : super(key: key);

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  Color? color;
  String title = DirectoryService.activeNodeHook.value.title;
  final unsubscribeCollect = UnsubscribeCollect([]);
  String syncTip = '';

  String syncStatusToStr(SyncStatus syncStatus) {
    switch (syncStatus) {
      case SyncStatus.DOWNLOAD:
        return '(下载中)';
      case SyncStatus.DOWNLOADED:
        return '';
      case SyncStatus.UPLOAD:
        return '(上传中)';
      case SyncStatus.UPLOADED:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    syncTip = syncStatusToStr(CacheService.syncStatus.value);
    unsubscribeCollect.addAll([
      CacheService.syncStatus.subscribe((value) {
        if (syncTip != syncStatusToStr(value)) {
          syncTip = syncStatusToStr(value);
          setState(() {});
        }
      }),
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
    Logger.info('Build widget ToolBar', symbol: 'build');
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
          IconContainer(
            iconData: IconFont.icon_sort,
            onTap: () {},
          ),
          Text('''$title$syncTip'''),
          IconContainer(
            iconData: IconFont.icon_notes,
            onTap: () async {
              await ChapterService.create();
            },
          ),
        ],
      ),
    );
  }
}
