import 'package:flutter/material.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../../../config/config.dart';

class CountSection extends StatelessWidget {
  final int count;
  final bool isActive;
  const CountSection({Key? key, required this.count, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget CountSection', symbol: 'build');
    return Text(
      '$count',
      style: TextStyle(
        color: Config.textGrey,
      ),
    );
  }
}
