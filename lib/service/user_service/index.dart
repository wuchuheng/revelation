import 'package:snotes/dao/user_dao/index.dart';
import 'package:snotes/model/user_model/user_model.dart';
import 'package:snotes/routes/route_path.dart';
import 'package:snotes/service/cache_service.dart';

class UserService {
  static UserModel? getUserInfo() => UserDao().has();

  static void disconnect() async {
    await CacheService.disconnect();
    RoutePath.pushLoginPage();
  }
}
