import 'package:flutter/material.dart';
import 'package:snotes/config/config.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class TitleSection extends StatelessWidget {
  final String title;
  final bool isActive;
  const TitleSection({Key? key, required this.title, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget TitleSection', symbol: 'build');
    return Text(
      ' $title',
      style: TextStyle(
        color: Config.fontColor,
      ),
    );
  }
}
