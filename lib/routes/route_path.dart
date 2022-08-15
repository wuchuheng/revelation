import 'package:hi_router/hi_router.dart';
import 'package:hi_router/route/route_abstract.dart';

import '../dao/sqlite_dao.dart';
import '../dao/user_dao/index.dart';
import '../model/user_model/user_model.dart';
import '../pages/home_page/index.dart';
import '../pages/login_page/index.dart';
import '../service/cache_service.dart';

/// 路由
class RoutePath {
  static HiRouter? _appRoutePathInstance;
  static pushHomePage() => RoutePath.getAppPathInstance().push('/');
  static pushLoginPage() => RoutePath.getAppPathInstance().push('/login');

  static HiRouter getAppPathInstance() {
    _appRoutePathInstance ??= HiRouter(
      {
        '/': () => HomePage(),
        '/login': () => LoginPage(),
      },
    );
    // 路由守卫
    _appRoutePathInstance!.before = (RoutePageInfo pageInfo) async {
      await SQLiteDao.init();
      final UserModel? user = UserDao().has();
      final loginPage = RoutePageInfo('/login', () => LoginPage());
      if (user == null) {
        return loginPage;
      } else {
        try {
          await CacheService.login(
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
