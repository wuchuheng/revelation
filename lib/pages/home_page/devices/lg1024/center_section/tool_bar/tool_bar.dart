import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revelation/api/cache_service.dart';
import 'package:revelation/common/iconfont.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/pages/home_page/devices/lg1024/center_section/tool_bar/icon_container.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class ToolBar extends StatefulWidget {
  final GlobalService globalService;
  const ToolBar({Key? key, required this.globalService}) : super(key: key);

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  Color? color;
  String title = '';
  final unsubscribeCollect = UnsubscribeCollect([]);
  String syncTip = '';

  String syncStatusToStr(SyncStatus syncStatus) {
    switch (syncStatus) {
      case SyncStatus.DOWNLOAD:
        return '(Downloading)';
      case SyncStatus.DOWNLOADED:
        return '';
      case SyncStatus.UPLOAD:
        return '(Uploading)';
      case SyncStatus.UPLOADED:
        return '';
    }
  }

  @override
  void initState() {
    String title = widget.globalService.directoryService.activeNodeHook.value.title;
    super.initState();
    syncTip = syncStatusToStr(widget.globalService.cacheService.syncStatus.value);
    unsubscribeCollect.addAll([
      widget.globalService.cacheService.syncStatus.subscribe((value, _) {
        if (syncTip != syncStatusToStr(value)) {
          syncTip = syncStatusToStr(value);
          setState(() {});
        }
      }),
      widget.globalService.directoryService.activeNodeHook.subscribe((data, _) {
        if (data.title != title) setState(() => title = data.title);
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
              await widget.globalService.chapterService.create();
            },
          ),
        ],
      ),
    );
  }
}
