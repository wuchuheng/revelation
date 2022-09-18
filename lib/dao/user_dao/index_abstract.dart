import 'package:revelation/model/user_model/user_model.dart';

abstract class UserDaoAbstract {
  void create(UserModel userModel);
  UserModel? has();
  void save(UserModel userModel);
}
