import 'package:revelation/dao/directory_dao/directory_dao_util.dart';
import 'package:revelation/dao/directory_dao/index_abstract.dart';
import 'package:revelation/dao/sqlite_dao.dart';
import 'package:revelation/model/directory_model/index.dart';
import 'package:sqlite3/sqlite3.dart';

class DirectoryDao implements DirectoryDaoAbstract {
  @override
  List<DirectoryModel> fetchAll() {
    final tableName = DirectoryModel.tableName;
    final db = SQLiteDao.getDb();
    final ResultSet fetchResult = db.select(''' select * from $tableName where deleted_at is null ''');
    List<DirectoryModel> result = [];
    for (Row row in fetchResult) {
      result.add(DirectoryDaoUtil.rowConvertDirectoryModel(row));
    }

    return result;
  }

  @override
  DirectoryModel save(DirectoryModel directory) {
    final tableName = DirectoryModel.tableName;
    final oldData = has(id: directory.id);
    final db = SQLiteDao.getDb();
    if (oldData != null) {
      db.execute('''
      UPDATE $tableName 
      SET pid = ?, 
      sort_num = ?,
      title = ?,
      deleted_at = ?,
      updated_at = ?
      WHERE id = ${directory.id}
      ''', [
        directory.pid,
        directory.sortNum,
        directory.title,
        directory.deletedAt?.toString(),
        directory.updatedAt.toString(),
      ]);
    } else {
      db.execute('''
      INSERT INTO $tableName (
         id,
        pid,
        sort_num,
        title,
        deleted_at,
        updated_at
      ) VALUES (?, ?, ?, ?, ?, ?);
      ''', [
        directory.id,
        directory.pid,
        directory.sortNum,
        directory.title,
        directory.deletedAt?.toString(),
        directory.updatedAt.toString(),
      ]);
    }

    return directory;
  }

  @override
  DirectoryModel? has({required int id}) {
    final db = SQLiteDao.getDb();
    final tableName = DirectoryModel.tableName;
    final result = db.select('select * from $tableName where id = $id');
    if (result.isNotEmpty) {
      final row = result[0];
      return DirectoryDaoUtil.rowConvertDirectoryModel(row);
    }
    return null;
  }

  @override
  void delete({required id}) {
    final db = SQLiteDao.getDb();
    final tableName = DirectoryModel.tableName;
    db.execute('''UPDATE $tableName SET deleted_at is null where id = $id ''');
  }
}
