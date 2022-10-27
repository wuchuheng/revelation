import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/pages/chapter_list_page/chapter_item.dart';
import 'package:revelation/routes/route_path.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import '../../common/phone_body_container/phone_body_container.dart';
import '../../common/phone_large_title_layout_container/phone_large_title_layout_container.dart';

class ChapterListPage extends StatefulWidget {
  final GlobalService globalService;
  ChapterListPage({super.key, required BuildContext context})
      : globalService = RepositoryProvider.of<GlobalService>(context);
  static Route<void> route(BuildContext context) =>
      MaterialPageRoute(builder: (_) => ChapterListPage(context: context));

  @override
  State<ChapterListPage> createState() => _ChapterListPageState();
}

class _ChapterListPageState extends State<ChapterListPage> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      widget.globalService.chapterService.chapterListHook.subscribe((value) {
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
    widget.globalService.chapterService.create();
    pushChapterDetailPage(context);
  }

  @override
  Widget build(BuildContext context) {
    final chapters = widget.globalService.chapterService.chapterListHook.value;
    final title = '${widget.globalService.directoryService.activeNodeHook.value.title}(${chapters.length})';

    final child = PhoneBodyContainer(
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

    return Scaffold(body: child);
  }
}
