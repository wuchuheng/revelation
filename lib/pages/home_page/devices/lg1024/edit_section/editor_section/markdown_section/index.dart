import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:snotes/config/config.dart';

class MarkdownSection extends StatefulWidget {
  final double width;
  final TextEditingController textEditingController;
  const MarkdownSection({Key? key, required this.width, required this.textEditingController}) : super(key: key);

  @override
  State<MarkdownSection> createState() => _MarkdownSectionState();
}

class _MarkdownSectionState extends State<MarkdownSection> {
  String text = '';

  @override
  void initState() {
    super.initState();
    text = widget.textEditingController.text;
    widget.textEditingController.addListener(() {
      if (text != widget.textEditingController.text && mounted) {
        setState(() => text = widget.textEditingController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
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
        data: text,
      ),
    );
  }
}
