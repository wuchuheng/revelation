import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../../../../../config/config.dart';

class IconContainer extends StatefulWidget {
  final IconData iconData;
  final Function() onTap;
  const IconContainer({
    Key? key,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  State<IconContainer> createState() => _IconContainerState();
}

class _IconContainerState extends State<IconContainer> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget IconContainer', symbol: 'build');
    const size = 30.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isHover ? Colors.grey[300] : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (e) {
          if (e != isHover) {
            setState(() => isHover = e);
          }
        },
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.iconData, color: isHover ? Colors.black : Config.iconColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
