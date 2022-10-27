import 'dart:async';

import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class GeneralService {
  final GlobalService _globalService;
  GeneralService({required GlobalService globalService}) : _globalService = globalService;

  Hook<DateTime?> lastSyncTimeHook = Hook(null);
  Hook<bool> syncStateHook = Hook(false);
  Hook<int> syncIntervalHook = Hook(5);
  Hook<int> timerHook = Hook(0);
  Timer? timer;

  setSyncState(bool value) {
    syncStateHook.set(value);
    timer?.cancel();
    const duration = Duration(seconds: 1);
    if (value) {
      timerHook.set(0);
      timer = Timer.periodic(duration, (timer) => timerHook.setCallback((data) => ++data));
    } else {
      timerHook.set(syncIntervalHook.value);
      timer = Timer.periodic(duration, (timer) => timerHook.setCallback((data) => --data));
    }
  }

  Future<void> setSyncInterval(int newInterval) async {
    await _globalService.cacheService.getImapCache().setSyncInterval(newInterval);
    syncIntervalHook.set(newInterval);
    setSyncState(syncStateHook.value);
  }
}
