import 'package:flutter/material.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class SyncStateSection extends StatefulWidget {
  GlobalService globalService;
  SyncStateSection({Key? key, required this.globalService}) : super(key: key);

  @override
  State<SyncStateSection> createState() => _SyncStateSectionState();
}

class _SyncStateSectionState extends State<SyncStateSection> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([
      widget.globalService.generalService.timerHook.subscribe(
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
    final color = widget.globalService.generalService.syncStateHook.value ? Colors.green : Colors.red;
    widget.globalService.generalService.lastSyncTimeHook;
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
        '${widget.globalService.generalService.timerHook.value}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
