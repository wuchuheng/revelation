import 'package:flutter/material.dart';
import 'package:snotes/common/iconfont.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/model/chapter_model/index.dart';
import 'package:snotes/routes/route_path.dart';
import 'package:snotes/service/chapter_service/index.dart';

class ChapterItem extends StatelessWidget {
  final ChapterModel chapter;
  final bool isLastItem;

  const ChapterItem({Key? key, required this.chapter, this.isLastItem = false}) : super(key: key);

  void onTap(BuildContext context) {
    ChapterService.setEditChapter(chapter);
    RoutePath.pushChapterDetailPage();
  }

  @override
  Widget build(BuildContext context) {
    final subTitleColor = Colors.grey[600];
    const double fontSize = 17;
    const double spaceGap = 1;
    final updatedAt = chapter.updatedAt;

    return LayoutBuilder(builder: (context, constraint) {
      return GestureDetector(
        onTap: () => onTap(context),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: constraint.maxWidth,
          decoration: BoxDecoration(
            border: isLastItem ? null : Border(bottom: BorderSide(width: 1, color: Config.borderColor)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chapter.title, style: const TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700)),
              Container(
                margin: const EdgeInsets.only(top: spaceGap, bottom: spaceGap),
                child: Text(
                  '${updatedAt.year}/${updatedAt.month}/${updatedAt.day} ${chapter.describe.isNotEmpty ? chapter.describe : '(No Data)'}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: subTitleColor),
                ),
              ),
              Row(
                children: [
                  Icon(
                    IconFont.icon_file_directory,
                    size: fontSize,
                    color: subTitleColor,
                  ),
                  Text(
                    ' ${chapter.directory.title}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: subTitleColor),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
