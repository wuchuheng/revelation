import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snotes/service/general_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class SyncStateSection extends StatefulWidget {
  const SyncStateSection({Key? key}) : super(key: key);

  @override
  State<SyncStateSection> createState() => _SyncStateSectionState();
}

class _SyncStateSectionState extends State<SyncStateSection> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  int num = 0;
  Timer? timer;

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      GeneralService.syncStateHook.subscribe(
        // if (timer != null) timer!.
        (value) {
          timer?.cancel();
          final duration = Duration(seconds: 1);
          if (value) {
            num = 0;
            timer = Timer.periodic(duration, (timer) {
              setState(() => ++num);
            });
          } else {
            num = GeneralService.syncIntervalHook.value;
            timer = Timer.periodic(duration, (timer) {
              setState(() => --num);
            });
          }
          setState(() {});
        },
      ),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = GeneralService.syncStateHook.value ? Colors.green : Colors.red;
    GeneralService.lastSyncTimeHook;
    double size = 20;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(size)),
      ),
      width: size,
      height: size,
      child: Text(
        '$num',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
