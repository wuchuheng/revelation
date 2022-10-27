import 'package:revelation/model/chapter_model/chapter_model.dart';
import 'package:revelation/utils/date_time_util.dart';
import 'package:sqlite3/sqlite3.dart';

class ChapterDaoUtil {
  static ChapterModel rowConvertChapterModel(Row row) {
    final updatedAt = row['updated_at'];
    final deletedAt = row['deleted_at'];
    return ChapterModel(
      id: row['id'],
      title: row['title'],
      content: row['content'],
      updatedAt: DateTimeUtil.convertTimeStr(updatedAt),
      deletedAt: deletedAt != null ? DateTimeUtil.convertTimeStr(deletedAt) : null,
      sortNum: row['sort_num'],
      directoryId: row['directory_id'],
    );
  }
}
