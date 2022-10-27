import 'package:revelation/model/directory_model/directory_model.dart';

abstract class DirectoryDaoAbstract {
  List<DirectoryModel> fetchAll();

  DirectoryModel save(DirectoryModel directory);

  DirectoryModel? has({required int id});

  void delete({required int id});
}
