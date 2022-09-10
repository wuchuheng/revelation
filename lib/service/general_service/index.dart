import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class GeneralService {
  static Hook<DateTime?> lastSyncTimeHook = Hook(null);
  static Hook<bool> syncStateHook = Hook(false);
}
