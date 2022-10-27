import 'package:revelation/model/chapter_model/chapter_model.dart';

abstract class ChapterDaoAbstract {
  ChapterModel save(ChapterModel chapter);
  ChapterModel? has({required int id});
  List<ChapterModel> fetchAll();
  List<ChapterModel> fetchByDirectoryId(int directoryId);
  int total();
}
