import 'dart:async';

import 'package:revelation/service/cache_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class GeneralService {
  static Hook<DateTime?> lastSyncTimeHook = Hook(null);
  static Hook<bool> syncStateHook = Hook(false);
  static Hook<int> syncIntervalHook = Hook(5);
  static Hook<int> timerHook = Hook(0);
  static Timer? timer;

  static setSyncState(bool value) {
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

  static Future<void> setSyncInterval(int newInterval) async {
    await CacheService.getImapCache().setSyncInterval(newInterval);
    syncIntervalHook.set(newInterval);
    setSyncState(syncStateHook.value);
  }
}
