import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:revelation/service/global_service.dart';
import 'package:uuid/uuid.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import '../../model/chapter_model/chapter_model.dart';
import '../../service/chapter_service/chapter_service.dart';

class EditorFieldSection extends StatefulWidget {
  final String content;
  final void Function(String content) onChange;
  final ChapterService chapterService;
  const EditorFieldSection({
    Key? key,
    required this.content,
    required this.onChange,
    required this.chapterService,
  }) : super(key: key);

  @override
  State<EditorFieldSection> createState() => _EditorFieldSectionState();
}

class _EditorFieldSectionState extends State<EditorFieldSection> {
  final textEditingController = TextEditingController();
  ChapterModel? chapter;
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  late String uuid;

  @override
  void initState() {
    uuid = const Uuid().v4();
    chapter = widget.chapterService.editChapterHook.value;
    if (chapter != null) {
      textEditingController.text = chapter!.content;
    }
    unsubscribeCollect = UnsubscribeCollect([
      widget.chapterService.editChapterHook.subscribe((data, cancel) {
        final bool isChapterNotNull = chapter != null;
        final bool isContentDifferent = data?.content != chapter?.content;
        final bool isDataNotNull = data != null;
        final bool isEditTextDifferent = textEditingController.text != data?.content;
        final bool isUUidDifferent = data?.uuid != uuid;

        if (isChapterNotNull && isContentDifferent && isDataNotNull && isEditTextDifferent && isUUidDifferent) {
          textEditingController.text = data.content;
          widget.onChange(data.content);
        }
        chapter = data;
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
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);
    return TextFormField(
      autofocus: false,
      style: TextStyle(fontSize: 14, height: 1.4, color: HexColor('#1C1F22')),
      onChanged: (String value) {
        final chapter = globalService.chapterService.editChapterHook.value!;
        chapter.content = value;
        chapter.uuid = uuid;
        widget.onChange(chapter.content);
        globalService.chapterService.onSave(chapter);
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
