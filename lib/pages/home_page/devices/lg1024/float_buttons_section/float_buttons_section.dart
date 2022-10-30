import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revelation/common/iconfont.dart';
import 'package:revelation/pages/home_page/devices/lg1024/float_buttons_section/button_section.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class FloatButtonSection extends StatefulWidget {
  final GlobalService globalService;
  const FloatButtonSection({Key? key, required this.globalService}) : super(key: key);

  @override
  State<FloatButtonSection> createState() => _FloatButtonsSectionState();
}

class _FloatButtonsSectionState extends State<FloatButtonSection> {
  double buttonCount = 3;
  final unsubscribeCollect = UnsubscribeCollect([]);
  late bool isPreview;
  late bool isSplittingPreview;

  @override
  void initState() {
    isPreview = widget.globalService.floatingToolBarService.isPreviewHook.value;
    isPreview = widget.globalService.floatingToolBarService.isPreviewHook.value;
    isSplittingPreview = widget.globalService.floatingToolBarService.isSplittingPreviewHook.value;
    super.initState();
    unsubscribeCollect.addAll([
      widget.globalService.floatingToolBarService.isPreviewHook.subscribe((data, _) {
        if (data != isPreview) setState(() => isPreview = data);
      }),
      widget.globalService.floatingToolBarService.isSplittingPreviewHook.subscribe((data, _) {
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
        onTap: widget.globalService.floatingToolBarService.onTapPreview,
      ),
      ButtonSection(
        isActive: isSplittingPreview,
        iconData: IconFont.icon_split,
        onTap: widget.globalService.floatingToolBarService.onTapSplittingPreview,
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
