import 'dart:math';

import 'package:flutter/material.dart';

class AdvanceSection extends StatefulWidget {
  final List<Widget> child;
  final double height;
  final void Function(AnimationController controller) onChangeController;
  const AdvanceSection({Key? key, required this.child, required this.height, required this.onChangeController})
      : super(key: key);

  @override
  State<AdvanceSection> createState() => _AdvanceSectionState();
}

class _AdvanceSectionState extends State<AdvanceSection> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  final animateEnd = pi * -0.5;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(microseconds: 200000), vsync: this);
    animation = Tween<double>(
      begin: 0,
      end: animateEnd,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.linear),
    );
    widget.onChangeController(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double marginSize = 10;
    clickContainer(Widget child) => MouseRegion(cursor: SystemMouseCursors.click, child: child);

    final height = widget.height * widget.child.length;
    return Container(
      margin: const EdgeInsets.only(bottom: marginSize),
      child: GestureDetector(
        onTap: () {
          if (controller.value == 0) {
            controller.forward(from: 0);
          }
          if (controller.value == 1) {
            controller.animateBack(0);
          }
        },
        child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: marginSize),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        clickContainer(
                          Transform.rotate(angle: animation.value, child: const Icon(Icons.arrow_left)),
                        ),
                        clickContainer(const Text('Advance')),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * controller.value,
                    child: ListView(
                      children: widget.child,
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
