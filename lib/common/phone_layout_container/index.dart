import 'package:flutter/material.dart';
import 'package:revelation/common/iconfont.dart';

import '../../config/config.dart';

class PhoneLayoutContainer extends StatefulWidget {
  final List<Widget> children;
  final IconButton? leading;
  final String title;
  const PhoneLayoutContainer({
    Key? key,
    required this.children,
    required this.title,
    this.leading,
  }) : super(key: key);

  @override
  State<PhoneLayoutContainer> createState() => _PhoneLayoutContainerState();
}

class _PhoneLayoutContainerState extends State<PhoneLayoutContainer> {
  final ScrollController scrollController = ScrollController();
  Border? bottomBarBorder = null;

  @override
  Widget build(BuildContext context) {
    const double marginSize = 10;
    return LayoutBuilder(builder: (context, constraint) {
      final maxHeight = constraint.maxHeight;
      const double barHeight = 0;

      return Column(children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight - barHeight),
          child: Container(
            height: maxHeight - barHeight,
            color: Config.backgroundColor,
            child: (CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar.large(
                  leading: widget.leading,
                  expandedHeight: 130,
                  backgroundColor: Config.backgroundColor,
                  title: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(IconFont.icon_notes, color: Colors.black),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      ...widget.children.map(
                        (child) => Container(
                          margin: const EdgeInsets.only(left: marginSize, right: marginSize),
                          child: child,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     border: Border(top: BorderSide(width: 1, color: Config.borderColor)),
        //   ),
        //   height: barHeight,
        //   child: Row(
        //     children: widget.bottomToolbar,
        //   ),
        // ),
      ]);
    });
  }
}
