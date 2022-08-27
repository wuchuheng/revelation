import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snotes/common/iconfont.dart';
import 'package:snotes/pages/home_page/devices/lg1024/float_buttons_section/button_section.dart';
import 'package:snotes/service/float_tool_bar_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class FloatButtonSection extends StatefulWidget {
  const FloatButtonSection({Key? key}) : super(key: key);

  @override
  State<FloatButtonSection> createState() => _FloatButtonsSectionState();
}

class _FloatButtonsSectionState extends State<FloatButtonSection> {
  double buttonCount = 3;
  final unsubscribeCollect = UnsubscribeCollect([]);
  bool isPreview = FloatingToolBarService.isPreviewHook.value;
  bool isSplittingPreview = FloatingToolBarService.isSplittingPreviewHook.value;

  @override
  void initState() {
    super.initState();
    unsubscribeCollect.addAll([
      FloatingToolBarService.isPreviewHook.subscribe((data) {
        if (data != isPreview) setState(() => isPreview = data);
      }),
      FloatingToolBarService.isSplittingPreviewHook.subscribe((data) {
        if (data != isSplittingPreview) setState(() => isSplittingPreview = data);
      })
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    unsubscribeCollect.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget FloatButtonSection', symbol: 'build');
    const spacing = 5.0;
    const size = 35.0;
    final childrenSection = <Widget>[
      ButtonSection(
        isActive: isPreview,
        iconData: IconFont.icon_preview,
        onTap: FloatingToolBarService.onTapPreview,
      ),
      ButtonSection(
        isActive: isSplittingPreview,
        iconData: IconFont.icon_split,
        onTap: FloatingToolBarService.onTapSplittingPreview,
      ),
    ];

    return SizedBox(
      height: size * childrenSection.length + (childrenSection.length - 1) * spacing,
      width: size,
      child: GridView.count(
        mainAxisSpacing: spacing,
        crossAxisCount: 1,
        children: childrenSection,
      ),
    );
  }
}
