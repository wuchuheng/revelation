import 'package:flutter/material.dart';
import 'package:revelation/service/global_service.dart';
import 'package:revelation/service/log_service/log_service.dart';

class FloatButtonsSection extends StatefulWidget {
  final GlobalService globalService;
  const FloatButtonsSection({Key? key, required this.globalService}) : super(key: key);

  @override
  State<FloatButtonsSection> createState() => _FloatButtonsSectionState();
}

class _FloatButtonsSectionState extends State<FloatButtonsSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.globalService.settingService.activeIndexHook.value != 2) {
      return const SizedBox.shrink();
    }
    const double buttonSize = 40;
    buttonContainer(Widget child) {
      return SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: FittedBox(child: child),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        buttonContainer(
          FloatingActionButton(
            key: const Key('counterView_increment_floatingActionButton'),
            child: const Icon(Icons.keyboard_arrow_up),
            onPressed: () => widget.globalService.logService.setCurrentPosition(CurrentPosition.top),
          ),
        ),
        const SizedBox(height: 8),
        buttonContainer(
          FittedBox(
            child: FloatingActionButton(
              key: const Key('counterView_decrement_floatingActionButton'),
              child: const Icon(Icons.keyboard_arrow_down),
              onPressed: () => widget.globalService.logService.setCurrentPosition(CurrentPosition.bottom),
            ),
          ),
        ),
      ],
    );
  }
}
