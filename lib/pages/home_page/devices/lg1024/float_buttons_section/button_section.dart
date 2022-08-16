import 'package:flutter/material.dart';

class ButtonSection extends StatefulWidget {
  final String message;
  final void Function() onTap;
  final IconData iconData;
  const ButtonSection({Key? key, required this.message, required this.onTap, required this.iconData}) : super(key: key);

  @override
  State<ButtonSection> createState() => _ButtonSectionState();
}

class _ButtonSectionState extends State<ButtonSection> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.message,
      child: MouseRegion(
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
              color: isHover ? Colors.grey[300] : null,
              border: isHover
                  ? Border.all(
                      color: Colors.grey[500]!,
                      width: 1,
                    )
                  : null,
              borderRadius: BorderRadius.all(const Radius.circular(100)),
            ),
            child: Icon(
              widget.iconData,
              color: isHover ? Colors.grey[900] : Colors.grey[400],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
