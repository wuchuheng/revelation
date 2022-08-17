import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:snotes/model/chapter_model/index.dart';

import 'code_element_builder.dart';

class MarkdownSection extends StatefulWidget {
  final ChapterModel chapter;
  final double width;
  const MarkdownSection({Key? key, required this.chapter, required this.width}) : super(key: key);

  @override
  State<MarkdownSection> createState() => _MarkdownSectionState();
}

class _MarkdownSectionState extends State<MarkdownSection> {
  @override
  Widget build(BuildContext context) {
    // final html = Markdown(
    //   selectable: true,
    //   data: widget.chapter.content,
    //   extensionSet: md.ExtensionSet(
    //     md.ExtensionSet.commonMark.blockSyntaxes,
    //     [
    //       md.EmojiSyntax(),
    //       ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
    //     ],
    //   ),
    // );

    final html = Markdown(
        key: const Key("defaultmarkdownformatter"),
        data: widget.chapter.content,
        selectable: true,
        padding: const EdgeInsets.all(10),
        builders: {
          'code': CodeElementBuilder(),
        });

    return Container(
      width: widget.width,
      height: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
      child: html,
    );
  }
}
