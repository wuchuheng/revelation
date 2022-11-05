import 'dart:async';

import 'package:flutter/material.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import '../../../api/cache_service.dart';

class RefreshIconSection extends StatefulWidget {
  final double toolbarFontSize;
  final GlobalService _globalService;
  const RefreshIconSection({Key? key, required this.toolbarFontSize, required GlobalService globalService})
      : _globalService = globalService,
        super(key: key);

  @override
  State<RefreshIconSection> createState() => _RefreshIconSectionState();
}

class _RefreshIconSectionState extends State<RefreshIconSection> {
  double turns = 0.0;
  bool isLoading = false;
  late Unsubscribe syncStatusSubscribe;
  Timer? timer;

  @override
  void initState() {
    syncStatusSubscribe = widget._globalService.cacheService.syncStatus.subscribe((syncStatus, _) {
      animatedRotation() {
        timer?.cancel();
        setState(() => turns += 1.0);
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() => turns += 1.0);
        });
      }

      cancelTimer() {
        if (timer != null) {
          Timer(const Duration(seconds: 1), () => timer?.cancel());
        }
      }

      switch (widget._globalService.cacheService.syncStatus.value) {
        case SyncStatus.DOWNLOAD:
          animatedRotation();
          break;
        case SyncStatus.DOWNLOADED:
          cancelTimer();
          break;
        case SyncStatus.UPLOAD:
          animatedRotation();
          break;
        case SyncStatus.UPLOADED:
          cancelTimer();
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    syncStatusSubscribe.unsubscribe();
    super.dispose();
  }

  void onRefresh() {}

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onRefresh,
      icon: AnimatedRotation(
        turns: turns,
        duration: const Duration(seconds: 1),
        child: Icon(Icons.refresh, size: widget.toolbarFontSize),
      ),
    );
  }
}
