import 'package:flutter/material.dart';
import 'package:revelation/pages/chapter_list_page/chapter_item.dart';
import 'package:revelation/routes/route_path.dart';
import 'package:revelation/service/chapter_service/index.dart';
import 'package:revelation/service/directory_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import '../../common/phone_body_container/index.dart';
import '../../common/phone_large_title_layout_container/index.dart';

class ChapterListPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return Scaffold(
          body: WillPopScope(
            child: const ChapterList(),
            onWillPop: () => Future.value(false),
          ),
        );
      },
    );
  }
}

class ChapterList extends StatefulWidget {
  const ChapterList({Key? key}) : super(key: key);

  @override
  State<ChapterList> createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      ChapterService.chapterListHook.subscribe(
        (value) => setState(() {}),
      ),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  void onCreate() async {
    await ChapterService.create();
    pushChapterDetailPage();
  }

  void onBack(BuildContext context) async {
    await route.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final chapters = ChapterService.chapterListHook.value;
    final title = '${DirectoryService.activeNodeHook.value.title}(${chapters.length})';

    return PhoneBodyContainer(
      child: PhoneLargeTitleLayoutContainer(
        leading: IconButton(
          onPressed: () => onBack(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        rightLeading: IconButton(
          onPressed: onCreate,
          icon: const Icon(Icons.add, color: Colors.black),
        ),
        title: title,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(children: [
              for (int index = 0; index < chapters.length; index++)
                ChapterItem(chapter: chapters[index], isLastItem: index + 1 == chapters.length)
            ]),
          )
        ],
      ),
    );
  }
}
