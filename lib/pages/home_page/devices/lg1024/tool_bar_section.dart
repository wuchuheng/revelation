import 'package:flutter/material.dart';
import 'package:snotes/pages/common_config.dart';

class ToolBarSection extends StatelessWidget {
  const ToolBarSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[200],
      width:
          MediaQuery.of(context).size.width - CommonConfig.lg1024DirectoryWidth,
      height: CommonConfig.toolBarHeight,
    );
  }
}
