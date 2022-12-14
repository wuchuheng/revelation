import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:revelation/config/config.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class MarkdownSection extends StatelessWidget {
  final double width;
  final String content;
  const MarkdownSection({Key? key, required this.width, required this.content}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget MarkdownSection', symbol: 'build');
    return Container(
      width: width,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: Config.borderColor,
          ),
        ),
      ),
      child: MarkdownWidget(
        data: content,
      ),
    );
  }
}
