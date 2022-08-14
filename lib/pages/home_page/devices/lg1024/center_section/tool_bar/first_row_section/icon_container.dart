import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../common_config.dart';

class IconContainer extends StatefulWidget {
  final IconData iconData;
  const IconContainer({
    Key? key,
    required this.iconData,
  }) : super(key: key);

  @override
  State<IconContainer> createState() => _IconContainerState();
}

class _IconContainerState extends State<IconContainer> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
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
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (e) {
          if (isHover != true) setState(() => isHover = true);
        },
        onExit: (e) {
          if (isHover != false) setState(() => isHover = false);
        },
        onHover: (v) {},
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.iconData, color: isHover ? Colors.black : CommonConfig.iconColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
