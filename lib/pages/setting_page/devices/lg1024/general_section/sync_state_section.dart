import 'package:flutter/material.dart';
import 'package:revelation/service/general_service/index.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class SyncStateSection extends StatefulWidget {
  const SyncStateSection({Key? key}) : super(key: key);

  @override
  State<SyncStateSection> createState() => _SyncStateSectionState();
}

class _SyncStateSectionState extends State<SyncStateSection> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      GeneralService.timerHook.subscribe(
        (value) => setState(() {}),
      ),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
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
      alignment: Alignment.center,
      width: size,
      height: size,
      child: Text(
        '${GeneralService.timerHook.value}',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
