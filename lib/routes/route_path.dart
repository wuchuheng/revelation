import 'package:hi_router/hi_router.dart';
import 'package:hi_router/route/route_abstract.dart';

import '../pages/home_page/index.dart';

/// 路由
class RoutePath {
  static HiRouter? _appRoutePathInstance;
  static pushLoginPage() => RoutePath.getAppPathInstance().push('/login');
  static pushRegisterPage() => RoutePath.getAppPathInstance().push('/register');
  static pushForgetPasswordPage() =>
      RoutePath.getAppPathInstance().push('/forgetPassword');

  static HiRouter getAppPathInstance() {
    _appRoutePathInstance ??= HiRouter({
      '/': () => HomePage(),
    });
    // 路由守卫
    _appRoutePathInstance!.before = (RoutePageInfo pageInfo) async {
      return pageInfo;
    };

    return _appRoutePathInstance!;
  }
}
