import 'package:revelation/dao/sqlite_dao.dart';
import 'package:revelation/dao/user_dao/index_abstract.dart';
import 'package:revelation/model/user_model/user_model.dart';
import 'package:sqlite3/sqlite3.dart';

class UserDao implements UserDaoAbstract {
  @override
  void create(UserModel user) {
    final db = SQLiteDao.getDb();
    final tableName = UserModel.tableName;
    db.execute('''
      INSERT INTO $tableName (
        user_name,
         password,
         imap_server_host,
        imap_server_port,
        is_imap_server_secure
      ) VALUES (?, ?, ?, ?, ?);
    ''', [
      user.userName,
      user.password,
      user.host,
      user.port,
      user.tls,
    ]);
  }

  @override
  UserModel? has() {
    final db = SQLiteDao.getDb();
    final tableName = UserModel.tableName;
    final result = db.select('SELECT * FROM $tableName LIMIT 1;');
    if (result.isNotEmpty) {
      final Row row = result[0];
      final user = UserModel(
        userName: row['user_name'],
        password: row['password'],
        host: row['imap_server_host'],
        port: row['imap_server_port'],
        tls: row['is_imap_server_secure'] > 0,
      );
      return user;
    }

    return null;
  }

  @override
  void save(UserModel userModel) {
    final db = SQLiteDao.getDb();
    db.execute('DELETE FROM ${UserModel.tableName};');
    create(userModel);
  }
}
