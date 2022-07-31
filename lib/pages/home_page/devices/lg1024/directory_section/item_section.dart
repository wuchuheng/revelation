import 'package:flutter/material.dart';

import '../../../../../common/iconfont.dart';

class ItemSection extends StatelessWidget {
  const ItemSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Icon(
          IconFont.icon_file_directory,
        ),
        Text(
          '1',
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dashed,
            // fontSize: 20,
            // fontWeight: FontWeight.w400,
            // textBaseline: null,
            // color: Colors.grey,
          ),
        )
      ],
    ));
  }
}
