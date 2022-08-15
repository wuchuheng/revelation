import 'package:snotes/model/directory_model/index.dart';
import 'package:sqlite3/sqlite3.dart';

class DirectoryDaoUtil {
  static DirectoryModel rowConvertDirectoryModel(Row row) {
    return DirectoryModel(
      id: row['id'],
      title: row['title'],
      updatedAt: row['updated_at'],
      pid: row['pid'],
      children: [],
      isDelete: row['is_delete'] > 0,
      count: 0,
      sortId: row['sort_id'],
    );
  }
}
