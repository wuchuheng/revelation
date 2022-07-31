import 'package:flutter/material.dart';

import '../../../../common_config.dart';

class ListAndEditContainer extends StatelessWidget {
  final List<Widget> children;

  const ListAndEditContainer({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - CommonConfig.toolBarHeight,
      width:
          MediaQuery.of(context).size.width - CommonConfig.lg1024DirectoryWidth,
      child: Row(
        children: children,
      ),
    );
  }
}
