import 'package:flutter/services.dart';
import 'package:revelation/pages/chapter_list_page/index.dart';
import 'package:revelation/pages/loading_page/index.dart';
import 'package:wuchuheng_env/wuchuheng_env.dart';
import 'package:wuchuheng_router/route/route_abstract.dart';
import 'package:wuchuheng_router/wuchuheng_router.dart';

import '../dao/sqlite_dao.dart';
import '../dao/user_dao/index.dart';
import '../model/user_model/user_model.dart';
import '../pages/chapter_detail_page/index.dart';
import '../pages/home_page/index.dart';
import '../pages/login_page/index.dart';
import '../pages/setting_page/index.dart';
import '../service/cache_service.dart';

bool isLoadEnv = false;
bool isSQLLiteInit = false;

const homeRoute = '/';
const loginRoute = '/login';
const settingRoute = '/setting';
const chapterListRoute = '/chapters';
const chapterDetailRoute = '/chapters/details';

onBefore(RoutePageInfo pageInfo) async {
  if (!isLoadEnv) {
    try {
      final content = await rootBundle.loadString('.env');
      DotEnv(content: content);
    } catch (e) {}
    isLoadEnv = true;
  }
  if (!isSQLLiteInit) {
    await SQLiteDao.init();
    isSQLLiteInit = true;
  }
  final UserModel? user = UserDao().has();
  final loginPage = RoutePageInfo(loginRoute, () => LoginPage());
  final isConnectImap = CacheService.isConnectHook.value;
  if (user == null) {
    return loginPage;
  } else if (!isConnectImap) {
    try {
      await CacheService.connect(
        userName: user.userName,
        password: user.password,
        imapServerHost: user.imapServerHost,
        imapServerPort: user.imapServerPort,
        isImapServerSecure: user.isImapServerSecure,
      );
    } catch (e) {
// :TODO logger
      return loginPage;
    }
  }

  return pageInfo;
}

final WuchuhengRouter route = WuchuhengRouter(
  {
    homeRoute: () => HomePage(),
    settingRoute: () => SettingPage(),
    loginRoute: () => LoginPage(),
    chapterListRoute: () => ChapterListPage(),
    chapterDetailRoute: () => ChapterDetailPage(),
  },
  loadingPage: const LoadingPage(),
  before: (RoutePageInfo pageInfo) => onBefore(pageInfo),
);

pushHomePage() => route.push(homeRoute);
pushLoginPage() => route.push(loginRoute);
pushSettingPage() => route.push(settingRoute);
pushChapterListPage() => route.push(chapterListRoute);
pushChapterDetailPage() => route.push(chapterDetailRoute);
