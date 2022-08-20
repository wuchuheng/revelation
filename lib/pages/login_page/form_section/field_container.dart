import 'package:flutter/material.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class FieldContainer extends StatelessWidget {
  final String label;
  final Widget child;
  const FieldContainer({Key? key, required this.label, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget FieldContainer', symbol: 'build');
    return Wrap(
      direction: Axis.horizontal,
      children: [
        SizedBox(
          width: 100,
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              '$label:',
              textAlign: TextAlign.right,
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tight(const Size(200, 50)),
          child: child,
        ),
      ],
    );
  }
}
