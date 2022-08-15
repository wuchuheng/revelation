import 'package:flutter/material.dart';
import 'package:snotes/config/config.dart';

class ToolBarSection extends StatelessWidget {
  const ToolBarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[200],
      width: MediaQuery.of(context).size.width - Config.lg1024DirectoryWidth,
      height: Config.toolBarHeight,
    );
  }
}
