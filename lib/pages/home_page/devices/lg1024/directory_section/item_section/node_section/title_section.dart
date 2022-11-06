import 'package:flutter/material.dart';
import 'package:revelation/config/config.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class TitleSection extends StatelessWidget {
  final double fontSize;
  final String title;
  final bool isActive;
  const TitleSection({Key? key, required this.title, required this.isActive, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget TitleSection', symbol: 'build');
    return Text(
      ' $title',
      style: TextStyle(
        fontSize: fontSize,
        color: Config.fontColor,
      ),
    );
  }
}
