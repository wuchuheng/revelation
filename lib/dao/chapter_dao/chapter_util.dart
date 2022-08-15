import 'package:snotes/model/chapter_model/index.dart';
import 'package:sqlite3/sqlite3.dart';

class ChapterDaoUtil {
  static ChapterModel rowConvertChapterModel(Row row) {
    return ChapterModel(
      id: row['id'],
      title: row['title'],
      content: row['content'],
      updatedAt: row['updated_at'],
      deletedAt: row['deleted_at'],
      sortNum: row['sort_num'],
      pid: row['pid'],
    );
  }
}
