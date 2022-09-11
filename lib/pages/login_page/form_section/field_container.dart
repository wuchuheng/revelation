import 'package:flutter/material.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class FieldContainer extends StatelessWidget {
  final double height;
  final String label;
  final Widget child;
  final CrossAxisAlignment cross;

  const FieldContainer(
      {Key? key, required this.label, required this.child, this.cross = CrossAxisAlignment.start, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget FieldContainer', symbol: 'build');
    return Row(
      crossAxisAlignment: cross,
      children: [
        SizedBox(
          width: 90,
          child: Padding(
            padding: const EdgeInsets.only(right: 7),
            child: Text(
              '$label:',
              textAlign: TextAlign.right,
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tight(Size(200, height)),
          child: child,
        ),
      ],
    );
  }
}
