import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:revelation/dao/sqlite_dao.dart';
import 'package:revelation/dao/user_dao/index.dart';
import 'package:revelation/model/user_model/user_model.dart';

void main() {
  test('TestCreateUser', () async {
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/path_provider');
    await SQLiteDao.init();
    final userDao = UserDao();
    userDao.create(
      UserModel(
          userName: 'userName',
          password: 'password',
          host: 'hello',
          port: 993,
          tls: true),
    );
  });
}
