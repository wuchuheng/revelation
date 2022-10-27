import 'package:flutter/material.dart';
import 'package:revelation/pages/chapter_list_page/chapter_item.dart';
import 'package:revelation/routes/route_path.dart';
import 'package:revelation/service/chapter_service/chapter_service.dart';
import 'package:revelation/service/directory_service/directory_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import '../../common/phone_body_container/phone_body_container.dart';
import '../../common/phone_large_title_layout_container/phone_large_title_layout_container.dart';

class ChapterListPage extends StatelessWidget {
  const ChapterListPage({super.key});
  static Route<void> route() => MaterialPageRoute(builder: (_) => const ChapterListPage());

  @override
  Widget build(BuildContext context) => const Scaffold(body: ChapterList());
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
      ChapterService.chapterListHook.subscribe((value) {
        setState(() {});
      }),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  void onCreate(BuildContext context) {
    ChapterService.create();
    pushChapterDetailPage(context);
  }

  @override
  Widget build(BuildContext context) {
    final chapters = ChapterService.chapterListHook.value;
    final title = '${DirectoryService.activeNodeHook.value.title}(${chapters.length})';

    return PhoneBodyContainer(
      child: PhoneLargeTitleLayoutContainer(
        leading: IconButton(
          onPressed: () => pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        rightLeading: IconButton(
          onPressed: () => onCreate(context),
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
