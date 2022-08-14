import 'package:flutter/material.dart';
import 'package:snotes/common/iconfont.dart';
import 'package:snotes/pages/common_config.dart';

class ItemSection extends StatelessWidget {
  final bool isFirst;

  const ItemSection({Key? key, this.isFirst = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const fontSize = 13.0;
    Color color = Colors.grey[600]!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      margin: EdgeInsets.only(
        left: CommonConfig.centerSectionItemGap,
        right: CommonConfig.centerSectionItemGap,
        top: isFirst ? CommonConfig.centerSectionItemGap : 0,
      ),
      padding: const EdgeInsets.all(CommonConfig.centerSectionItemGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'This is a Container',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          Row(
            children: [
              Text('12:00', style: const TextStyle(fontSize: fontSize)),
              Text(' 温和给人的意图定性', style: TextStyle(color: color, fontSize: fontSize))
            ],
          ),
          Row(
            children: [
              Icon(IconFont.icon_file_directory, size: fontSize, color: color),
              Text('  目录', style: TextStyle(fontSize: fontSize, color: color)),
            ],
          )
        ],
      ),
    );
  }
}
