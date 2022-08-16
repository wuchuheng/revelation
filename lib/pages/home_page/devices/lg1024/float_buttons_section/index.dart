import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snotes/common/iconfont.dart';
import 'package:snotes/pages/home_page/devices/lg1024/float_buttons_section/button_section.dart';

class FloatButtonSection extends StatefulWidget {
  const FloatButtonSection({Key? key}) : super(key: key);

  @override
  State<FloatButtonSection> createState() => _FloatButtonsSectionState();
}

class _FloatButtonsSectionState extends State<FloatButtonSection> {
  double buttonCount = 3;

  @override
  Widget build(BuildContext context) {
    const spacing = 5.0;
    const size = 35.0;
    final childrenSection = <Widget>[
      ButtonSection(
        iconData: IconFont.icon_preview,
        message: 'preview',
        onTap: () {
          print('preview');
        },
      ),
      ButtonSection(
        iconData: IconFont.icon_split,
        message: 'split',
        onTap: () {
          print('split');
        },
      ),
    ];

    return Container(
      height: size * childrenSection.length + (childrenSection.length - 1) * spacing,
      width: size,
      child: GridView.count(
        mainAxisSpacing: spacing,
        crossAxisCount: 1,
        children: childrenSection,
      ),
    );
  }
}
