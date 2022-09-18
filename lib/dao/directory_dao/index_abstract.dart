import 'package:revelation/model/directory_model/index.dart';

abstract class DirectoryDaoAbstract {
  List<DirectoryModel> fetchAll();

  DirectoryModel save(DirectoryModel directory);

  DirectoryModel? has({required int id});

  void delete({required int id});
}
