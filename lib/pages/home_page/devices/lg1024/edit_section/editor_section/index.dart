import 'package:flutter/material.dart';
import 'package:snotes/pages/home_page/devices/lg1024/edit_section/editor_section/markdown_section/index.dart';
import 'package:snotes/service/float_tool_bar_service/index.dart';
import 'package:wuchuheng_helper/wuchuheng_helper.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';
import 'package:yaml/yaml.dart';

import '../../../../../../model/chapter_model/index.dart';
import '../../../../../../service/chapter_service/index.dart';

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
  ChapterModel? chapter = ChapterService.editChapterHook.value;
  String content = ChapterService.editChapterHook.value?.content ?? '';
  bool isPreview = FloatingToolBarService.isPreviewHook.value;

  final onSave = Helper.debounce((ChapterModel newChapter) {
    final chapter = ChapterService.editChapterHook.value;
    if (chapter?.id == newChapter.id) {
      chapter!.content = newChapter.content;
      final regexp = RegExp(r'(?<=---)(.*?)(?=---)', multiLine: true, dotAll: true);
      final pregResult = regexp.firstMatch(chapter.content)?.group(0);
      if (pregResult != null) {
        var doc = loadYaml(pregResult) as Map;
        chapter.title = doc['title'] ?? '';
      }
      chapter.updatedAt = DateTime.now();
      ChapterService.setEditChapter(chapter);
    }
  }, 1000);

  @override
  void initState() {
    if (chapter != null) {
      textEditingController.text = chapter!.content;
    }
    unsubscribeCollect.addAll([
      ChapterService.editChapterHook.subscribe((data) {
        if (chapter != null &&
            data?.content != chapter?.content &&
            data != null &&
            textEditingController.text != data.content) {
          textEditingController.text = data.content;
          content = data.content;
        }
        if (chapter?.id != data?.id) {
          chapter = data;
          setState(() {});
        }
      }),
      FloatingToolBarService.isSplittingPreviewHook.subscribe((value) {
        if (value != isSplittingPreview) setState(() => isSplittingPreview = value);
      }),
      FloatingToolBarService.isPreviewHook.subscribe((value) => setState(() => isPreview = value))
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  Widget getTextFormField(double width) {
    Logger.info('Build TextFormField', symbol: 'build');
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          cursorColor: Colors.black,
          autofocus: true,
          onChanged: (String value) {
            final chapter = ChapterService.editChapterHook.value!;
            chapter.content = value;
            setState(() => content = value);
            onSave(chapter);
          },
          controller: textEditingController,
          maxLines: 200,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "",
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget EditorSection', symbol: 'build');

    conatainer(Widget child) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: widget.width,
        child: child,
      );
    }

    if (isSplittingPreview || isPreview) {
      return conatainer(Row(
        children: [
          if (!isPreview) getTextFormField(widget.width / 2),
          MarkdownSection(
            width: isPreview ? widget.width : widget.width / 2,
            content: content,
          )
        ],
      ));
    } else {
      return getTextFormField(widget.width);
    }
  }
}
