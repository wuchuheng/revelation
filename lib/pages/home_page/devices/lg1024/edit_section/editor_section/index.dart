import 'package:flutter/material.dart';
import 'package:snotes/common/editor_section/index.dart';
import 'package:snotes/service/float_tool_bar_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../../common/markdown_section/index.dart';
import '../../../../../../service/chapter_service/index.dart';

class EditorSection extends StatefulWidget {
  final double width;
  const EditorSection({Key? key, required this.width}) : super(key: key);

  @override
  State<EditorSection> createState() => _EditorSectionState();
}

class _EditorSectionState extends State<EditorSection> {
  final UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  bool isSplittingPreview = FloatingToolBarService.isSplittingPreviewHook.value;
  String content = ChapterService.editChapterHook.value?.content ?? '';
  bool isPreview = FloatingToolBarService.isPreviewHook.value;

  @override
  void initState() {
    unsubscribeCollect.addAll([
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
        child: EditorFieldSection(
          content: content,
          onChange: (String newContent) => setState(() => content = newContent),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget EditorSection', symbol: 'build');
    container(Widget child) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: widget.width,
        child: child,
      );
    }

    if (isSplittingPreview || isPreview) {
      return container(Row(
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
