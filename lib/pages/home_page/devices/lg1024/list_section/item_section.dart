import 'package:flutter/material.dart';
import 'package:smtpnotes/common/iconfont.dart';

class ItemSection extends StatelessWidget {
  const ItemSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const fontSize = 13.0;
    Color color = Colors.grey[600]!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      padding: EdgeInsets.all(8),
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
              Text('12:00', style: TextStyle(fontSize: fontSize)),
              Text(' 温和给人的意图定性',
                  style: TextStyle(color: color, fontSize: fontSize))
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
