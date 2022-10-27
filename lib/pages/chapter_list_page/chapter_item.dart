import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/common/iconfont.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/model/chapter_model/chapter_model.dart';
import 'package:revelation/routes/route_path.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_ui/wuchuheng_ui.dart';

class ChapterItem extends StatelessWidget {
  final ChapterModel chapter;
  final bool isLastItem;

  const ChapterItem({Key? key, required this.chapter, this.isLastItem = false}) : super(key: key);

  void onTap(BuildContext context) {
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);

    globalService.chapterService.setEditChapter(chapter);
    pushChapterDetailPage(context);
  }

  final radius = const Radius.circular(10);

  void onConfirmDelete(BuildContext context) {
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);
    onDialog(
      context: context,
      title: 'Delete Data',
      describe: 'Are you sure?',
      onConfirm: () => globalService.chapterService.delete(chapter),
    );
  }

  void _showMenu(BuildContext context) {
    onBottomSheet(
      context: context,
      items: [BottomSheetItem(title: 'Delete', color: Colors.red, key: 'delete')],
      onTap: (key) => onConfirmDelete(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subTitleColor = Colors.grey[600];
    const double fontSize = 17;
    const double spaceGap = 1;
    final updatedAt = chapter.updatedAt;

    return LayoutBuilder(builder: (context, constraint) {
      return GestureDetector(
        onLongPress: () => _showMenu(context),
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
