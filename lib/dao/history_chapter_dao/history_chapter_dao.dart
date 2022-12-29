import 'package:revelation/model/history_chapter_model/history_chapter_model.dart';
import 'package:sqlite3/common.dart';

import '../../utils/date_time_util.dart';
import '../sqlite_dao.dart';

abstract class HistoryChapterDaoAbstract {
  HistoryChapterModel save(HistoryChapterModel value);

  HistoryChapterModel? findLastByPid(int pid);

  List<HistoryChapterModel> fetchListByPid(int pid);

  int getTotalByPid(int pid);
}

class HistoryChapterDao implements HistoryChapterDaoAbstract {
  final db = SQLiteDao.getDb();
  String tableName = HistoryChapterModel.tableName;

  @override
  HistoryChapterModel save(HistoryChapterModel value) {
    db.execute('''
      INSERT INTO $tableName (
        pid,
        title,
        content,
        created_at
      ) values ( ?, ?, ?, ? )
      ''', [
      value.pid,
      value.title,
      value.content,
      value.createdAt.toString(),
    ]);

    return findLastByPid(value.pid)!;
  }

  @override
  HistoryChapterModel? findLastByPid(int pid) {
    ResultSet fetchResult = db.select("select * from $tableName where pid = $pid ORDER BY id desc Limit 1");
    if (fetchResult.isEmpty) {
      return null;
    }

    return rowConvertHistoryChapterModel(fetchResult[0]);
  }

  static HistoryChapterModel rowConvertHistoryChapterModel(Row row) {
    final createdAt = DateTimeUtil.convertTimeStr(row['created_at']);

    return HistoryChapterModel(
        id: row['id'], title: row['title'], content: row['content'], createdAt: createdAt, pid: row['pid']);
  }

  @override
  List<HistoryChapterModel> fetchListByPid(int pid) {
    ResultSet fetchResult = db.select("select * from $tableName where pid = $pid ORDER BY id desc");
    List<HistoryChapterModel> result = [];
    for (int i = 0; i < fetchResult.length; i++) {
      result.add(rowConvertHistoryChapterModel(fetchResult[i]));
    }

    return result;
  }

  @override
  int getTotalByPid(int pid) {
    final ResultSet fetchResult = db.select('''SELECT count(*) as total FROM $tableName WHERE pid = $pid;''');

    return fetchResult[0]['total'];
  }
}
