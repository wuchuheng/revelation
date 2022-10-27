import 'package:revelation/service/setting_service/setting_service.dart';
import 'package:revelation/service/user_service/user_service.dart';

import '../api/cache_service.dart';
import 'chapter_service/chapter_service.dart';
import 'directory_service/directory_service.dart';
import 'float_tool_bar_service/float_tool_bar_service.dart';
import 'general_service/general_service.dart';
import 'log_service/log_service.dart';

class GlobalService {
  late CacheService cacheService;
  late DirectoryService directoryService;
  late ChapterService chapterService;
  late GeneralService generalService;
  late SettingService settingService;
  late UserService userService;
  late LogService logService;
  late FloatingToolBarService floatingToolBarService;

  GlobalService() {
    cacheService = CacheService(globalService: this);
    directoryService = DirectoryService(globalService: this);
    chapterService = ChapterService(globalService: this);
    generalService = GeneralService(globalService: this);
    settingService = SettingService(globalService: this);
    userService = UserService(globalService: this);
    logService = LogService(globalService: this);
    floatingToolBarService = FloatingToolBarService();
  }
}
