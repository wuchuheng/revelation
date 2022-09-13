import 'package:flutter/material.dart';

class PhoneBodyContainer extends StatelessWidget {
  final Widget child;
  const PhoneBodyContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topHeight = MediaQuery.of(context).viewPadding.top;
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height),
        child: child,
      ),
    );
  }
}
