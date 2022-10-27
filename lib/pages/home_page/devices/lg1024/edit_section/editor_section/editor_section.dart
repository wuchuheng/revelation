import 'package:flutter/material.dart';
import 'package:revelation/common/editor_section/editor_section.dart';
import 'package:revelation/service/float_tool_bar_service/float_tool_bar_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../../common/markdown_section/markdown_section.dart';
import '../../../../../../service/chapter_service/chapter_service.dart';

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
      ChapterService.editChapterHook.subscribe((value) {
        content = value?.content ?? '';
        setState(() {});
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
    const double tipHeight = 20;
    return SizedBox(
      width: width,
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: tipHeight),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: EditorFieldSection(
                  content: content,
                  onChange: (String newContent) => setState(() => content = newContent),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: SizedBox(
              height: tipHeight,
              width: width,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Last updated at 7:00',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
            ),
          )
        ],
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
