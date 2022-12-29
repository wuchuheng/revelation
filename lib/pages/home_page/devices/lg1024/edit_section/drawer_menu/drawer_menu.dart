import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/common/iconfont.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/dao/history_chapter_dao/history_chapter_dao.dart';
import 'package:revelation/model/chapter_model/chapter_model.dart';
import 'package:revelation/model/history_chapter_model/history_chapter_model.dart';
import 'package:revelation/pages/home_page/devices/lg1024/edit_section/drawer_menu/revision_history/revision_history.dart';
import 'package:revelation/service/global_service.dart';
import 'package:revelation/utils/date_time_util.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class DrawerMenu extends StatefulWidget {
  GlobalService globalService;
  DrawerMenu({Key? key, required this.globalService}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  ChapterModel? chapter;
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  final double itemContainerMarginTop = 10;

  int historyTotal = 0;

  void calculateHistoryTotalByChapter(ChapterModel? chapterModel) {
    if (chapterModel != null) historyTotal = HistoryChapterDao().getTotalByPid(chapterModel.id);
  }

  @override
  void initState() {
    super.initState();
    chapter = widget.globalService.chapterService.editChapterHook.value;
    calculateHistoryTotalByChapter(chapter);
    unsubscribeCollect = UnsubscribeCollect(
      [
        widget.globalService.chapterService.editChapterHook.subscribe((value, cancel) {
          if (value?.id != chapter?.id) {
            chapter = value;
            calculateHistoryTotalByChapter(value);
            setState(() {});
          }
        }),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    unsubscribeCollect.unsubscribe();
  }

  Widget ItemContainer({required Widget child}) =>
      Container(margin: EdgeInsets.only(top: itemContainerMarginTop), child: child);

  Widget Divider() {
    return Container(
      margin: EdgeInsets.only(top: itemContainerMarginTop, bottom: itemContainerMarginTop),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Config.borderColor, width: 2),
        ),
      ),
    );
  }

  HistoryChapterModel? activeHistoryChapter;

  void onRollback() {
    if (activeHistoryChapter != null) {
      final ChapterModel chapter = widget.globalService.chapterService.editChapterHook.value!;
      chapter.title = activeHistoryChapter!.title;
      chapter.content = activeHistoryChapter!.content;
      widget.globalService.chapterService.onSave(chapter);
    }
  }

  void onShowDialog(BuildContext context) {
    textButton(String text, {required BuildContext ctx, void Function()? onTap}) {
      return TextButton(
        onPressed: () {
          Navigator.of(ctx).pop();
          if (onTap != null) {
            onTap();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Text(text),
        ),
      );
    }

    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Revision History"),
        content: RevisionHistory(
            globalService: globalService,
            onActiveHistoryChapter: (v) {
              activeHistoryChapter = v;
            }),
        actions: <Widget>[
          textButton('Cancel', ctx: ctx),
          textButton('Rollback', ctx: ctx, onTap: onRollback),
        ],
      ),
    );
  }

  Widget MenuItem({required Widget child, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        onShowDialog(context);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: EdgeInsets.only(top: itemContainerMarginTop),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              child,
              const Icon(IconFont.icon_right),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: [
          ListTile(
            title: const Text('NOTE INFORMATION'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItemContainer(
                  child: Text('Title: ${chapter?.title}'),
                ),
                ItemContainer(
                  child: Text(
                      'Updated at: ${chapter?.updatedAt != null ? DateTimeUtil.formatDateTime(chapter!.updatedAt) : ''}'),
                ),
                ItemContainer(
                    child: Text(
                        'Created at: ${chapter?.createdAt != null ? DateTimeUtil.formatDateTime(chapter!.createdAt) : ''}'))
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: const Text('ACTIONS'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuItem(
                  child: Text('Revision History ($historyTotal)'),
                  context: context,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
