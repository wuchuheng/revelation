import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:revelation/common/editor_section/index.dart';
import 'package:revelation/common/iconfont.dart';
import 'package:revelation/routes/route_path.dart';
import 'package:revelation/service/chapter_service/index.dart';
import 'package:revelation/service/directory_service/index.dart';

import '../../config/config.dart';

class ChapterDetailPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (BuildContext context) => const _ChapterDetailPage());
  }
}

class _ChapterDetailPage extends StatefulWidget {
  const _ChapterDetailPage({Key? key}) : super(key: key);

  @override
  State<_ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<_ChapterDetailPage> {
  bool isPreview = false;
  void onPressed(BuildContext context) async {
    await RoutePath.getAppPathInstance().pop(context);
  }

  TextEditingController textEditingController = TextEditingController();

  void onChangePreview() {
    setState(() => isPreview = !isPreview);
  }

  @override
  Widget build(BuildContext context) {
    final activeNodeTitle = DirectoryService.activeNodeHook.value.title;
    const double toolBarHeight = 50;
    const double toolbarFontSize = 19;
    double leftRightPaddingSize = 5;
    editSection() => Container(
          padding: EdgeInsets.only(left: leftRightPaddingSize, right: leftRightPaddingSize),
          child: EditorFieldSection(content: '', onChange: (value) {}),
        );

    preview() {
      final content = ChapterService.editChapterHook.value?.content ?? '';

      return MarkdownWidget(
        data: content,
      );
      // return MarkdownSection(width: 400, content: content);
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
            height: toolBarHeight,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Config.borderColor))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => onBack(context),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios, size: toolbarFontSize),
                      Text(
                        activeNodeTitle,
                        style: const TextStyle(fontSize: toolbarFontSize),
                      )
                    ],
                  ),
                ),
                IconButton(onPressed: onChangePreview, icon: const Icon(IconFont.icon_preview, size: toolbarFontSize))
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - toolBarHeight,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - leftRightPaddingSize * 2),
              child: isPreview ? preview() : editSection(),
            ),
          )
        ],
      ),
    );
  }

  void onBack(BuildContext context) async {
    await RoutePath.getAppPathInstance().pop(context);
  }
}
