import 'package:flutter/material.dart';
import 'package:snotes/common/iconfont.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/model/chapter_model/index.dart';
import 'package:snotes/service/chapter_service/index.dart';
import 'package:snotes/utils/subscription_builder/subscription_builder_abstract.dart';

class ItemSection extends StatefulWidget {
  final bool isFirst;
  final ChapterModel chapter;
  const ItemSection({Key? key, required this.isFirst, required this.chapter}) : super(key: key);

  @override
  State<ItemSection> createState() => _ItemSectionState();
}

class _ItemSectionState extends State<ItemSection> {
  final UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    isActive = ChapterService.editChapterHook.value?.id == widget.chapter.id;
    unsubscribeCollect.addAll([
      ChapterService.editChapterHook.subscribe((data) {
        final result = ChapterService.editChapterHook.value?.id == widget.chapter.id;
        if (result != isActive) setState(() => isActive = result);
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
    const fontSize = 13.0;
    Color color = Colors.grey[600]!;

    return GestureDetector(
      onTap: () => ChapterService.editChapterHook.set(widget.chapter),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isActive ? Config.activeColor : Colors.grey[200],
        ),
        margin: EdgeInsets.only(
          left: Config.centerSectionItemGap,
          right: Config.centerSectionItemGap,
          top: widget.isFirst ? Config.centerSectionItemGap : 0,
        ),
        padding: const EdgeInsets.all(Config.centerSectionItemGap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.chapter.title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
            Row(
              children: [
                Text('${widget.chapter.updatedAt.hour}:${widget.chapter.updatedAt.minute}',
                    style: const TextStyle(fontSize: fontSize)),
                Text(' 温和给人的意图定性', style: TextStyle(color: color, fontSize: fontSize))
              ],
            ),
            Row(
              children: [
                Icon(IconFont.icon_file_directory, size: fontSize, color: color),
                Text('  ${widget.chapter.directory.title}', style: TextStyle(fontSize: fontSize, color: color)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
