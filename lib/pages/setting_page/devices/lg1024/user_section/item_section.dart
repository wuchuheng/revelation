import 'package:flutter/material.dart';

class ItemSection extends StatelessWidget {
  final String label;
  String value;
  final bool isPassword;
  bool isSwitch;

  ItemSection({
    Key? key,
    required this.label,
    required this.value,
    this.isPassword = false,
    this.isSwitch = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buildContext, constraint) {
      final labelWidth = constraint.maxWidth * .4;
      value = isPassword ? List.generate(value.length, (index) => '*').toList().join('') : value;
      const double fontSize = 18;
      late Widget valueResult;
      if (isSwitch) {
        valueResult = const Switch(value: true, onChanged: null);
      } else {
        valueResult = Text(value, style: const TextStyle(fontSize: fontSize));
      }

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
              SizedBox(
                width: constraint.maxWidth - labelWidth,
                child: valueResult,
              )
            ],
          ));
    });
  }
}
