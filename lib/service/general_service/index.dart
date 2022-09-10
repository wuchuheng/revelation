import 'package:snotes/service/cache_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class GeneralService {
  static Hook<DateTime?> lastSyncTimeHook = Hook(null);
  static Hook<bool> syncStateHook = Hook(false);
  static Hook<int> syncIntervalHook = Hook(5);

  static Future<void> setSyncInterval(int newInterval) async {
    await CacheService.getImapCache().setSyncInterval(newInterval);
    syncIntervalHook.set(newInterval);
  }
}
