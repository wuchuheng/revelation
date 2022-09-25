import 'package:flutter/material.dart';
import 'package:revelation/service/device_service/index.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class FieldContainer extends StatelessWidget {
  final double height;
  final String label;
  final Widget child;
  final CrossAxisAlignment cross;

  const FieldContainer(
      {Key? key,
      required this.label,
      required this.child,
      this.cross = CrossAxisAlignment.center,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget FieldContainer', symbol: 'build');
    late double width;
    switch (DeviceService.deviceHook.value) {
      case DeviceType.phone:
        width = 80;
        break;
      case DeviceType.windows:
        width = 90;
        break;
    }
    return Row(
      crossAxisAlignment: cross,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width,
          alignment: Alignment.center,
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
