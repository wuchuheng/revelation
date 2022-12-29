import 'package:flutter/material.dart';
import 'package:revelation/common/editor_section/editor_section.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../../common/iconfont.dart';
import '../../../../../../common/markdown_section/markdown_section.dart';
import '../../float_buttons_section/button_section.dart';

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
  final titleController = TextEditingController();

  @override
  void initState() {
    isPreview = widget.globalService.floatingToolBarService.isPreviewHook.value;
    isSplittingPreview = widget.globalService.floatingToolBarService.isSplittingPreviewHook.value;
    content = widget.globalService.chapterService.editChapterHook.value?.content ?? '';
    titleController.text = widget.globalService.chapterService.editChapterHook.value?.title ?? '';
    unsubscribeCollect.addAll([
      widget.globalService.chapterService.editChapterHook.subscribe((value, _) {
        content = value?.content ?? '';
        if (titleController.text != value?.title) {
          titleController.text = value!.title;
        }
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

  void onChangeTitle(String value) {
    final chapter = widget.globalService.chapterService.editChapterHook.value!;
    chapter.title = value;
    widget.globalService.chapterService.onSave(chapter);
  }

  Widget getTextFormField(double width) {
    Logger.info('Build TextFormField', symbol: 'build');

    const double tipHeight = Config.centerSectionToolBarHeight;

    final editor = EditorFieldSection(
      content: content,
      onChange: (String newContent) => setState(() => content = newContent),
      chapterService: widget.globalService.chapterService,
    );

    final Widget titleBar = Positioned(
      top: 0,
      left: 0,
      child: Container(
        height: tipHeight,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Config.borderColor),
          ),
        ),
        padding: const EdgeInsets.only(left: 10, right: 10),
        width: width,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: width * .8,
              child: TextField(
                onChanged: onChangeTitle,
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Untitled',
                  border: InputBorder.none,
                ),
              ),
            ),
            const Spacer(), // use Spacer
            RotationTransition(
              turns: const AlwaysStoppedAnimation(90 / 360),
              child: ButtonSection(
                isActive: isSplittingPreview,
                iconData: IconFont.icon_menu,
                onTap: () => widget.globalService.chapterService.onOpenChapterMenu(context),
              ),
            ),
          ],
        ),
      ),
    );

    return SizedBox(
      width: width,
      child: Stack(
        children: <Widget>[
          titleBar,
          Container(
            margin: const EdgeInsets.only(top: tipHeight),
            child: editor,
          ),
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
