import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snotes/pages/home_page/devices/lg1024/edit_section/editor_section/markdown_section/index.dart';
import 'package:snotes/service/float_tool_bar_service/index.dart';

import '../../../../../../model/chapter_model/index.dart';
import '../../../../../../service/chapter_service/index.dart';
import '../../../../../../utils/subscription_builder/subscription_builder_abstract.dart';

class EditorSection extends StatefulWidget {
  final double width;
  const EditorSection({Key? key, required this.width}) : super(key: key);

  @override
  State<EditorSection> createState() => _EditorSectionState();
}

class _EditorSectionState extends State<EditorSection> {
  final UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  ChapterModel? chapter = ChapterService.editChapterHook.value;
  final textEditingController = TextEditingController();
  bool isSplittingPreview = FloatingToolBarService.isSplittingPreviewHook.value;

  @override
  void initState() {
    if (chapter != null) textEditingController.text = chapter!.content;
    unsubscribeCollect.addAll([
      ChapterService.editChapterHook.subscribe((data) {
        if (data?.id != chapter?.id && data != null) {
          textEditingController.text = data.content;
        }
        chapter = data;
        setState(() {});
      }),
      FloatingToolBarService.isSplittingPreviewHook.subscribe((value) {
        if (value != isSplittingPreview) setState(() => isSplittingPreview = value);
      }),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  onChanged(String value) async {
    chapter!.content = value;
    ChapterService.setEditChapter(chapter!);
  }

  Widget getTextFormField(double width) {
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          autofocus: true,
          controller: textEditingController,
          onChanged: onChanged,
          maxLines: 200,
          decoration: const InputDecoration.collapsed(
            border: InputBorder.none,
            hintText: "",
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = isSplittingPreview && chapter != null
        ? Row(
            children: [
              getTextFormField(widget.width / 2),
              MarkdownSection(
                width: widget.width / 2,
                chapter: chapter!,
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
