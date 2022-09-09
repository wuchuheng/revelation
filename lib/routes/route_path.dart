import 'package:flutter/services.dart';
import 'package:snotes/pages/loading_page/index.dart';
import 'package:wuchuheng_env/wuchuheng_env.dart';
import 'package:wuchuheng_router/route/route_abstract.dart';
import 'package:wuchuheng_router/wuchuheng_router.dart';

import '../dao/sqlite_dao.dart';
import '../dao/user_dao/index.dart';
import '../model/user_model/user_model.dart';
import '../pages/home_page/index.dart';
import '../pages/login_page/index.dart';
import '../pages/setting_page/index.dart';
import '../service/cache_service.dart';

bool isLoadEnv = false;

const homeRoute = '/';
const loginRoute = '/login';
const settingRoute = '/setting';

/// 路由
class RoutePath {
  static HiRouter? _appRoutePathInstance;
  static pushHomePage() => RoutePath.getAppPathInstance().push(homeRoute);
  static pushLoginPage() => RoutePath.getAppPathInstance().push(loginRoute);
  static pushSettingPage() => RoutePath.getAppPathInstance().push(settingRoute);

  static HiRouter getAppPathInstance() {
    _appRoutePathInstance ??= HiRouter(
      {
        // homeRoute: () => SettingPage(),
        homeRoute: () => HomePage(),
        settingRoute: () => SettingPage(),
        loginRoute: () => LoginPage(),
      },
    );
    _appRoutePathInstance!.setLoadingPage(const LoadingPage());
    // 路由守卫
    _appRoutePathInstance!.before = (RoutePageInfo pageInfo) async {
      if (!isLoadEnv) {
        try {
          final content = await rootBundle.loadString('.env');
          DotEnv(content: content);
        } catch (e) {}
        isLoadEnv = true;
      }
      await SQLiteDao.init();
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
          return loginPage;
        }
      }

      return pageInfo;
    };

    return _appRoutePathInstance!;
  }
}
