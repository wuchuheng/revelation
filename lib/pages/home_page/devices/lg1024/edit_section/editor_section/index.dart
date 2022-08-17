import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snotes/pages/home_page/devices/lg1024/edit_section/editor_section/markdown_section/index.dart';
import 'package:snotes/service/float_tool_bar_service/index.dart';

import '../../../../../../model/chapter_model/index.dart';
import '../../../../../../service/chapter_service/index.dart';
import '../../../../../../utils/helper.dart';
import '../../../../../../utils/subscription_builder/subscription_builder_abstract.dart';

class EditorSection extends StatefulWidget {
  final double width;
  const EditorSection({Key? key, required this.width}) : super(key: key);

  @override
  State<EditorSection> createState() => _EditorSectionState();
}

class _EditorSectionState extends State<EditorSection> {
  final UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  final textEditingController = TextEditingController();
  bool isSplittingPreview = FloatingToolBarService.isSplittingPreviewHook.value;

  final onSave = Helper.debounce((ChapterModel newChapter) {
    final chapter = ChapterService.editChapterHook.value;
    if (chapter?.id == newChapter.id) {
      chapter!.content = newChapter.content;
      ChapterService.setEditChapter(chapter);
    }
  }, 1000);

  @override
  void initState() {
    final chapter = ChapterService.editChapterHook.value;
    if (chapter != null) {
      textEditingController.text = chapter.content;
    }
    unsubscribeCollect.addAll([
      ChapterService.editChapterHook.subscribe((data) {
        if (chapter != null && data?.id != chapter.id && data != null && textEditingController.text != data.content) {
          textEditingController.text = data.content;
        }
      }),
      FloatingToolBarService.isSplittingPreviewHook.subscribe((value) {
        if (value != isSplittingPreview) setState(() => isSplittingPreview = value);
      }),
    ]);
    textEditingController.addListener(() {
      final chapter = ChapterService.editChapterHook.value;
      if (chapter != null) {
        chapter.content = textEditingController.text;
        // onSave(chapter);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  Widget getTextFormField(double width) {
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          cursorColor: Colors.black,
          autofocus: true,
          controller: textEditingController,
          maxLines: 200,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "",
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().toString());
    final result = isSplittingPreview
        ? Row(
            children: [
              getTextFormField(widget.width / 2),
              MarkdownSection(
                width: widget.width / 2,
                textEditingController: textEditingController,
              )
            ],
          )
        : getTextFormField(widget.width);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: widget.width,
      child: result,
    );
  }
}
