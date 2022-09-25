import 'package:flutter/material.dart';

import '../../config/config.dart';

class PhoneLargeTitleLayoutContainer extends StatefulWidget {
  final List<Widget> children;
  final IconButton? leading;
  final IconButton? rightLeading;
  final String title;
  const PhoneLargeTitleLayoutContainer({
    Key? key,
    required this.children,
    required this.title,
    this.leading,
    this.rightLeading,
  }) : super(key: key);

  @override
  State<PhoneLargeTitleLayoutContainer> createState() => _PhoneLargeTitleLayoutContainerState();
}

class _PhoneLargeTitleLayoutContainerState extends State<PhoneLargeTitleLayoutContainer> {
  final ScrollController scrollController = ScrollController();
  Border? bottomBarBorder;

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
                  leading: widget.leading ??
                      IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Colors.black,
                          )),
                  expandedHeight: 130,
                  backgroundColor: Config.backgroundColor,
                  title: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                  actions: [if (widget.rightLeading != null) widget.rightLeading!],
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
      ]);
    });
  }
}
