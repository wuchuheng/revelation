import 'package:snotes/dao/sqlite_dao.dart';
import 'package:snotes/dao/user_dao/index_abstract.dart';
import 'package:snotes/model/user_model/user_model.dart';
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
      user.imapServerHost,
      user.imapServerPort,
      user.isImapServerSecure,
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
        imapServerHost: row['imap_server_host'],
        imapServerPort: row['imap_server_port'],
        isImapServerSecure: row['is_imap_server_secure'] > 0,
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
