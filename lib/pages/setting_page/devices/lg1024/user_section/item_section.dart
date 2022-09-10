import 'package:flutter/material.dart';

class ItemSection extends StatelessWidget {
  final String label;
  Widget child;

  ItemSection({
    Key? key,
    required this.label,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buildContext, constraint) {
      final labelWidth = constraint.maxWidth * .4;
      const double fontSize = 18;

      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Container(
              width: labelWidth,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                '$label:',
                style: const TextStyle(fontSize: fontSize),
              ),
            ),
            child,
          ],
        ),
      );
    });
  }
}
