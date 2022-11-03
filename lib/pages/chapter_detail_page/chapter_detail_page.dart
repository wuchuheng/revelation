import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:revelation/common/editor_section/editor_section.dart';
import 'package:revelation/common/iconfont.dart';
import 'package:revelation/pages/chapter_detail_page/refresh_icon_section/refresh_icon_section.dart';
import 'package:revelation/routes/route_path.dart';
import 'package:revelation/service/global_service.dart';

import '../../config/config.dart';

class ChapterDetailPage extends StatefulWidget {
  const ChapterDetailPage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const ChapterDetailPage());

  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  bool isPreview = true;
  void onPressed(BuildContext context) => pop(context);

  TextEditingController textEditingController = TextEditingController();

  void onChangePreview() {
    setState(() => isPreview = !isPreview);
  }

  void onBack(BuildContext context) => pop(context);

  @override
  Widget build(BuildContext context) {
    final globalService = RepositoryProvider.of<GlobalService>(context);

    final activeNodeTitle = globalService.directoryService.activeNodeHook.value.title;
    double toolBarHeight = 40 + MediaQuery.of(context).viewPadding.top;
    const double toolbarFontSize = 19;
    double leftRightPaddingSize = 7;
    editSection() => Container(
          padding: EdgeInsets.only(left: leftRightPaddingSize, right: leftRightPaddingSize),
          child: EditorFieldSection(content: '', onChange: (value) {}, chapterService: globalService.chapterService),
        );

    preview() {
      final content = globalService.chapterService.editChapterHook.value?.content ?? '';
      return MarkdownWidget(
        data: content,
      );
    }

    const double buttonSize = 42;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
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
                RefreshIconSection(toolbarFontSize: toolbarFontSize, globalService: globalService),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FittedBox(
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                key: const Key('counterView_increment_floatingActionButton'),
                child: !isPreview
                    ? const Icon(IconFont.icon_preview, color: Colors.grey, size: 38)
                    : const Icon(IconFont.icon_notes, color: Colors.grey, size: 30),
                onPressed: () => onChangePreview(),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
