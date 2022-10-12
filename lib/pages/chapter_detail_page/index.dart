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
    await route.pop(context);
  }

  TextEditingController textEditingController = TextEditingController();

  void onChangePreview() {
    setState(() => isPreview = !isPreview);
  }

  void onBack(BuildContext context) async {
    await route.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final activeNodeTitle = DirectoryService.activeNodeHook.value.title;
    double toolBarHeight = 40 + MediaQuery.of(context).viewPadding.top;
    const double toolbarFontSize = 19;
    double leftRightPaddingSize = 7;
    editSection() => Container(
          padding: EdgeInsets.only(left: leftRightPaddingSize, right: leftRightPaddingSize),
          child: EditorFieldSection(content: '', onChange: (value) {}),
        );

    preview() {
      final content = ChapterService.editChapterHook.value?.content ?? '';
      return MarkdownWidget(
        data: content,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top, left: 10, right: 10),
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
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: double.infinity,
                ),
                height: MediaQuery.of(context).size.height - toolBarHeight - MediaQuery.of(context).viewInsets.bottom,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - leftRightPaddingSize * 2),
                  child: isPreview ? preview() : editSection(),
                ),
              ),
            ),
          ],
        ),
        onWillPop: () => Future.value(false),
      ),
    );
  }
}
