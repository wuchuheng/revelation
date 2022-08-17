import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart';
import 'package:snotes/model/chapter_model/index.dart';

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
    final String htmlString = markdownToHtml(widget.chapter.content);
    Widget html = Html(data: htmlString);

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
