import 'package:flutter/material.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/dao/history_chapter_dao/history_chapter_dao.dart';
import 'package:revelation/model/history_chapter_model/history_chapter_model.dart';
import 'package:revelation/pages/home_page/devices/lg1024/center_section/empty_section.dart';
import 'package:revelation/pages/home_page/devices/lg1024/edit_section/drawer_menu/revision_history/revision_history_content/revision_history_content.dart';
import 'package:revelation/service/global_service.dart';
import 'package:revelation/utils/date_time_util.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class RevisionHistory extends StatefulWidget {
  GlobalService globalService;
  void Function(HistoryChapterModel value) onActiveHistoryChapter;
  RevisionHistory({Key? key, required this.globalService, required this.onActiveHistoryChapter}) : super(key: key);

  @override
  State<RevisionHistory> createState() => _RevisionHistoryState();
}

class _RevisionHistoryState extends State<RevisionHistory> {
  int activeIndex = 0;
  List<HistoryChapterModel> items = [];
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    int id = widget.globalService.chapterService.editChapterHook.value!.id;
    items = HistoryChapterDao().fetchListByPid(id);
    if (items.isNotEmpty) widget.onActiveHistoryChapter(items[0]);
    unsubscribeCollect = UnsubscribeCollect([
      widget.globalService.chapterService.editChapterHook.subscribe((value, cancel) {
        items = HistoryChapterDao().fetchListByPid(id);
        setState(() {});
      }),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    unsubscribeCollect.unsubscribe();
  }

  double padding = 10;

  Widget Item(HistoryChapterModel value, {required bool isActive, required void Function() onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.only(left: padding, top: padding, bottom: padding),
        margin: EdgeInsets.only(right: padding),
        decoration: BoxDecoration(
          color: isActive ? Config.primaryColor : null,
          borderRadius: Config.borderRadius,
        ),
        child: Text(
          DateTimeUtil.formatDateTime(value.createdAt),
          style: TextStyle(color: isActive ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  void onTapItem(int index) {
    activeIndex = index;
    setState(() {});
    widget.onActiveHistoryChapter(items[activeIndex]);
  }

  @override
  Widget build(BuildContext context) {
    const double width = 800;

    return SizedBox(
      width: width,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: width,
          maxHeight: 500,
        ),
        child: items.isEmpty
            ? const EmptySection()
            : Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ListView(
                      children: [
                        for (int i = 0; i < items.length; i++)
                          Item(items[i], isActive: activeIndex == i, onTap: () => onTapItem(i)),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(width: 1, color: Config.borderColor)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        padding: EdgeInsets.only(left: padding),
                        child: RevisionHistoryContent(historyChapter: items[activeIndex])),
                  ),
                ],
              ),
      ),
    );
  }
}
