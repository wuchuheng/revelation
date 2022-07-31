import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smtpnotes/model/directory_model.dart';
import '../../../../../common/iconfont.dart';

class ItemSection extends StatefulWidget {
  final DirectoryModel data;
  final int level;
  final int activeId;
  final Function onChange;

  const ItemSection({
    super.key,
    required this.data,
    this.level = 0,
    required this.activeId,
    required this.onChange,
  });

  @override
  State<ItemSection> createState() => _ItemSectionState();
}

class _ItemSectionState extends State<ItemSection> {
  bool isOpenFold = true;

  Widget _getDirectIcon() {
    return GestureDetector(
      onTap: () => setState(() => isOpenFold = !isOpenFold),
      child: Container(
          width: 20,
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: widget.data.children.isNotEmpty
              ? Icon(
                  isOpenFold ? IconFont.icon_bottom : IconFont.icon_right,
                  size: 13,
                )
              : null),
    );
  }

  Widget _getItem() {
    double padding = (10 * widget.level).toDouble();
    bool isActive = widget.activeId == widget.data.id;

    return GestureDetector(
        onTap: () {
          widget.onChange(widget.data.id);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: isActive ? HexColor('##E4C65E') : null,
          ),
          margin: const EdgeInsets.only(top: 5),
          padding: EdgeInsets.only(left: padding, top: 5, bottom: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _getDirectIcon(),
                  Icon(
                    IconFont.icon_file_directory,
                    size: 17.5,
                    color: isActive ? Colors.white : Colors.black,
                  ),
                  Text(
                    ' ${widget.data.title}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              Text(
                '${widget.data.count}',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[500],
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getItem(),
        if (isOpenFold)
          for (DirectoryModel item in widget.data.children)
            ItemSection(
              key: ValueKey(item.id),
              data: item,
              level: widget.level + 1,
              activeId: widget.activeId,
              onChange: widget.onChange,
            )
      ],
    );
  }
}
