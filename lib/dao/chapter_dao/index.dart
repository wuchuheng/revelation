import 'package:snotes/dao/chapter_dao/chapter_util.dart';
import 'package:snotes/dao/chapter_dao/index_abstract.dart';
import 'package:snotes/dao/sqlite_dao.dart';
import 'package:snotes/model/chapter_model/index.dart';
import 'package:sqlite3/sqlite3.dart';

class ChapterDao implements ChapterDaoAbstract {
  @override
  ChapterModel save(ChapterModel chapter) {
    final db = SQLiteDao.getDb();
    final hasChapter = has(id: chapter.id);
    return chapter;
  }

  @override
  ChapterModel? has({required id}) {
    final db = SQLiteDao.getDb();
    String tableName = ChapterModel.tableName;
    final ResultSet result = db.select("select * from $tableName where id = ? and deleted_at is null", [id]);
    if (result.isNotEmpty) {
      final Row row = result[0];
      return ChapterDaoUtil.rowConvertChapterModel(row);
    }

    return null;
  }
}
