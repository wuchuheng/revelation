import 'package:path_provider/path_provider.dart';
import 'package:revelation/dao/directory_dao/index.dart';
import 'package:revelation/model/chapter_model/index.dart';
import 'package:revelation/model/directory_model/index.dart';
import 'package:revelation/model/user_model/user_model.dart';
import 'package:sqlite3/sqlite3.dart';

class SQLiteDao {
  static Database? _db;
  static Database getDb() {
    if (_db == null) {
      throw Error();
    }
    return _db!;
  }

  static Future<Database> init() async {
    if (_db != null) {
      return getDb();
    }
    final directory = await getApplicationDocumentsDirectory();
    final file = '${directory.path}/sqlite3.so';
    _db = sqlite3.open(file);
    final db = getDb();
    final hasUserTable = db.select(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='${UserModel.tableName}'",
    );
    if (hasUserTable.isEmpty) _createUserTable();
    final hasChapterTable = db.select(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='${ChapterModel.tableName}'",
    );
    if (hasChapterTable.isEmpty) _createChapterTable();
    final hasDirectoryTable = db.select(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='${DirectoryModel.tableName}'",
    );
    if (hasDirectoryTable.isEmpty) _createDirectory();

    return getDb();
  }

  static void _createUserTable() {
    final db = getDb();
    db.execute('''
      CREATE TABLE "${UserModel.tableName}" (
        "user_name" TEXT,
        "password" TEXT,
        "imap_server_host" TEXT,
        "imap_server_port" integer,
        "is_imap_server_secure" integer
      );
  ''');
  }

  static void _createChapterTable() {
    final tableName = ChapterModel.tableName;
    final db = getDb();
    db.execute('''
      CREATE TABLE $tableName (
        "id" INTEGER NOT NULL,
        "title" TEXT,
        "content" TEXT,
        "directory_id" INTEGER,
        "sort_num" INTEGER,
        "updated_at" DATE,
        "deleted_at" DATE,
        PRIMARY KEY ("id")
      );
  ''');
  }

  static void _createDirectory() {
    final tableName = DirectoryModel.tableName;
    final db = getDb();
    db.execute('''
      CREATE TABLE $tableName (
        "id" INTEGER NOT NULL,
        "pid" INTEGER,
        "title" TEXT,
        "sort_num" INTEGER,
        "deleted_at" DATE,
        "updated_at" DATE,
        PRIMARY KEY ("id")
      );
  ''');
    DirectoryDao().save(DirectoryModel.getRootNodeInitData());
  }
}
