import 'package:snotes/model/chapter_model/index.dart';

abstract class ChapterDaoAbstract {
  ChapterModel save(ChapterModel chapter);
  ChapterModel? has({required int id});
}