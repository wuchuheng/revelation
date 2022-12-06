import 'package:flutter/material.dart';
import 'package:revelation/common/editor_section/editor_section.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../../common/markdown_section/markdown_section.dart';

class EditorSection extends StatefulWidget {
  final double width;
  final GlobalService globalService;
  const EditorSection({Key? key, required this.width, required this.globalService}) : super(key: key);

  @override
  State<EditorSection> createState() => _EditorSectionState();
}

class _EditorSectionState extends State<EditorSection> {
  final UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  late bool isSplittingPreview;
  late String content;
  late bool isPreview;

  @override
  void initState() {
    isPreview = widget.globalService.floatingToolBarService.isPreviewHook.value;
    isSplittingPreview = widget.globalService.floatingToolBarService.isSplittingPreviewHook.value;
    content = widget.globalService.chapterService.editChapterHook.value?.content ?? '';
    unsubscribeCollect.addAll([
      widget.globalService.chapterService.editChapterHook.subscribe((value, _) {
        content = value?.content ?? '';
        setState(() {});
      }),
      widget.globalService.floatingToolBarService.isSplittingPreviewHook.subscribe((value, _) {
        if (value != isSplittingPreview) setState(() => isSplittingPreview = value);
      }),
      widget.globalService.floatingToolBarService.isPreviewHook
          .subscribe((value, _) => setState(() => isPreview = value))
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
    final updateAt = widget.globalService.chapterService.editChapterHook.value!.updatedAt;

    const double tipHeight = 20;

    final editor = EditorFieldSection(
      content: content,
      onChange: (String newContent) => setState(() => content = newContent),
      chapterService: widget.globalService.chapterService,
    );
    return SizedBox(
      width: width,
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: tipHeight),
            child: editor,
          ),
          Positioned(
            top: 0,
            child: SizedBox(
              height: tipHeight,
              width: width,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Last updated at ${updateAt.hour}:${updateAt.minute}',
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
