import 'package:flutter/material.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class ButtonSection extends StatefulWidget {
  final void Function() onTap;
  final IconData iconData;
  final bool isActive;
  const ButtonSection({Key? key, required this.onTap, required this.iconData, required this.isActive})
      : super(key: key);

  @override
  State<ButtonSection> createState() => _ButtonSectionState();
}

class _ButtonSectionState extends State<ButtonSection> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget ButtonSection', symbol: 'build');

    if (widget.isActive) isHover = true;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (e) {
        if (isHover != true) setState(() => isHover = true);
      },
      onExit: (e) {
        if (isHover != false) setState(() => isHover = false);
      },
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isActive ? Colors.grey[300] : null,
            border: widget.isActive
                ? Border.all(
                    color: Colors.grey[500]!,
                    width: 1,
                  )
                : null,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
          child: Icon(
            widget.iconData,
            color: widget.isActive ? Colors.grey[900] : Colors.grey[400],
            size: 20,
          ),
        ),
      ),
    );
  }
}
