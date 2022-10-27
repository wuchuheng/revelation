import 'package:flutter/material.dart';

class PhoneBodyContainer extends StatelessWidget {
  final Widget child;
  const PhoneBodyContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: height),
        child: child,
      ),
    );
  }
}
