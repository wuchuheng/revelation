import 'package:flutter/material.dart';
import 'package:snotes/common/iconfont.dart';

class PhoneLayoutContainer extends StatelessWidget {
  final List<Widget> children;
  const PhoneLayoutContainer({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double marginSize = 20;
    return LayoutBuilder(builder: (context, constraint) {
      final maxHeight = constraint.maxHeight;
      const double barHeight = 45;
      double sliverHeight = maxHeight - barHeight;
      return Column(children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight - barHeight),
          child: SizedBox(
            height: maxHeight - barHeight,
            child: (CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  expandedHeight: 130,
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Folders',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
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
                      ...children.map((child) => Container(
                            margin: EdgeInsets.only(left: marginSize, right: marginSize),
                            child: child,
                          ))
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
