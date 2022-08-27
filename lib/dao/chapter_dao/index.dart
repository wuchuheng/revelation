import 'package:snotes/dao/chapter_dao/chapter_util.dart';
import 'package:snotes/dao/chapter_dao/index_abstract.dart';
import 'package:snotes/dao/sqlite_dao.dart';
import 'package:snotes/model/chapter_model/index.dart';
import 'package:sqlite3/sqlite3.dart';

class ChapterDao implements ChapterDaoAbstract {
  @override
  ChapterModel save(ChapterModel chapter) {
    final db = SQLiteDao.getDb();
    final tableName = ChapterModel.tableName;
    final oldData = has(id: chapter.id);
    if (oldData == null) {
      db.execute('''
      INSERT INTO $tableName (
        id,
        title,
        content,
        updated_at,
        deleted_at,
        sort_num,
        directory_id
      ) values ( ?, ?, ?, ?, ?, ?, ? )
      ''', [
        chapter.id,
        chapter.title,
        chapter.content,
        chapter.updatedAt.toString(),
        chapter.deletedAt?.toString(),
        chapter.sortNum,
        chapter.directoryId,
      ]);
    } else {
      db.execute('''
      UPDATE $tableName SET 
        id = ? ,
        title = ?,
        content = ?,
        updated_at = ?,
        deleted_at = ?,
        sort_num = ?,
        directory_id = ?
        where id = ${chapter.id}
      ''', [
        chapter.id,
        chapter.title,
        chapter.content,
        chapter.updatedAt.toString(),
        chapter.deletedAt?.toString(),
        chapter.sortNum,
        chapter.directoryId,
      ]);
    }

    return chapter;
  }

  @override
  ChapterModel? has({required id}) {
    final db = SQLiteDao.getDb();
    String tableName = ChapterModel.tableName;
    final ResultSet result = db.select("select * from $tableName where id = ? and deleted_at is null Limit 1", [id]);
    if (result.isNotEmpty) {
      final Row row = result[0];
      return ChapterDaoUtil.rowConvertChapterModel(row);
    }

    return null;
  }

  @override
  List<ChapterModel> fetchAll() {
    final db = SQLiteDao.getDb();
    String tableName = ChapterModel.tableName;
    final ResultSet fetchResult = db.select("select * from $tableName where deleted_at is null ORDER BY id desc");
    List<ChapterModel> result = [];
    if (fetchResult.isNotEmpty) {
      for (Row row in fetchResult) {
        result.add(ChapterDaoUtil.rowConvertChapterModel(row));
      }
    }

    return result;
  }

  @override
  List<ChapterModel> fetchByDirectoryId(int directoryId) {
    final tableName = ChapterModel.tableName;
    final db = SQLiteDao.getDb();
    final ResultSet fetchResult = db.select(
      ''' select * from $tableName where deleted_at is null and directory_id = $directoryId ORDER BY id desc''',
    );
    List<ChapterModel> result = [];
    for (Row row in fetchResult) {
      result.add(ChapterDaoUtil.rowConvertChapterModel(row));
    }

    return result;
  }

  @override
  int total() {
    final tableName = ChapterModel.tableName;
    final db = SQLiteDao.getDb();
    final ResultSet fetchResult = db.select('''SELECT count(*) as total FROM $tableName WHERE deleted_at is null;''');

    return fetchResult[0]['total'];
  }
}
