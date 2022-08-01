import 'package:flutter/material.dart';
import 'package:snotes/pages/common_config.dart';

class ToolBarListEditContainer extends StatelessWidget {
  final List<Widget> children;

  const ToolBarListEditContainer({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width:
          MediaQuery.of(context).size.width - CommonConfig.lg1024DirectoryWidth,
      child: Column(
        children: children,
      ),
    );
  }
}
