import 'package:snotes/model/directory_model/index.dart';
import 'package:snotes/utils/date_time_util.dart';
import 'package:sqlite3/sqlite3.dart';

class DirectoryDaoUtil {
  static DirectoryModel rowConvertDirectoryModel(Row row) {
    return DirectoryModel(
      id: row['id'],
      title: row['title'],
      updatedAt: DateTimeUtil.convertTimeStr(row['updated_at']),
      pid: row['pid'],
      children: [],
      deletedAt: row['deleted_at'] != null ? DateTimeUtil.convertTimeStr(row['deleted_at']) : null,
      count: 0,
      sortId: row['sort_id'],
    );
  }
}
