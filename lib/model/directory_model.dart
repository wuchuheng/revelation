class DirectoryModel {
  int id;
  String title;
  int count;
  List<DirectoryModel> children;

  DirectoryModel({
    required this.title,
    required this.count,
    required this.children,
    required this.id,
  });
}
