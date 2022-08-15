import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snotes/dao/sqlite_dao.dart';
import 'package:snotes/dao/user_dao/index.dart';
import 'package:snotes/model/user_model/user_model.dart';

void main() {
  test('TestCreateUser', () async {
    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
    await SQLiteDao.init();
    final userDao = UserDao();
    userDao.create(
      UserModel(
          userName: 'userName',
          password: 'password',
          imapServerHost: 'hello',
          imapServerPort: 993,
          isImapServerSecure: true),
    );
  });
}
