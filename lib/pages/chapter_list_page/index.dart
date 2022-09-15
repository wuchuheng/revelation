import 'package:flutter/material.dart';
import 'package:snotes/pages/chapter_list_page/chapter_item.dart';
import 'package:snotes/routes/route_path.dart';
import 'package:snotes/service/chapter_service/index.dart';
import 'package:snotes/service/directory_service/index.dart';

import '../../common/phone_body_container/index.dart';
import '../../common/phone_layout_container/index.dart';

class ChapterListPage extends Page {
  void onBack(BuildContext context) async {
    await RoutePath.getAppPathInstance().pop(context);
  }

  @override
  Route createRoute(BuildContext context) {
    final chapters = ChapterService.chapterListHook.value;
    final title = '${DirectoryService.activeNodeHook.value.title}(${chapters.length})';
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return Scaffold(
          body: PhoneBodyContainer(
            child: PhoneLayoutContainer(
              leading: IconButton(
                onPressed: () => onBack(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
          ),
        );
      },
    );
  }
}
