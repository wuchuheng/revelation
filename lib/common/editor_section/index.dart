import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import '../../model/chapter_model/index.dart';
import '../../service/chapter_service/index.dart';

class EditorFieldSection extends StatefulWidget {
  final String content;
  final void Function(String content) onChange;
  const EditorFieldSection({Key? key, required this.content, required this.onChange}) : super(key: key);

  @override
  State<EditorFieldSection> createState() => _EditorFieldSectionState();
}

class _EditorFieldSectionState extends State<EditorFieldSection> {
  final textEditingController = TextEditingController();
  ChapterModel? chapter = ChapterService.editChapterHook.value;
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    if (chapter != null) {
      textEditingController.text = chapter!.content;
    }
    unsubscribeCollect = UnsubscribeCollect([
      ChapterService.editChapterHook.subscribe((data) {
        if (chapter != null &&
            data?.content != chapter?.content &&
            data != null &&
            textEditingController.text != data.content) {
          textEditingController.text = data.content;
          widget.onChange(data.content);
        }
        if (chapter?.id != data?.id) {
          chapter = data;
          setState(() {});
        }
      }),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      style: TextStyle(fontSize: 14, height: 1.4, color: HexColor('#1C1F22')),
      onChanged: (String value) {
        final chapter = ChapterService.editChapterHook.value!;
        chapter.content = value;
        widget.onChange(chapter.content);
        ChapterService.onSave(chapter);
      },
      controller: textEditingController,
      maxLines: 200,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "",
      ),
    );
  }
}
