import 'package:revelation/model/directory_model/directory_model.dart';
import 'package:revelation/utils/date_time_util.dart';
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
      sortNum: row['sort_num'],
    );
  }
}
