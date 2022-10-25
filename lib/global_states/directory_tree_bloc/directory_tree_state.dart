part of 'directory_tree_bloc.dart';

class DirectoryTreeState extends Equatable {
  final List<DirectoryModel> directoryTree;

  const DirectoryTreeState._({
    this.directoryTree = const [],
  });

  /// Initialization data.
  const DirectoryTreeState.init() : this._();

  /// Change the state of the directory tree.
  const DirectoryTreeState.directoryTreeChanged({required List<DirectoryModel> directoryTree})
      : this._(directoryTree: directoryTree);

  @override
  List<Object?> get props => [directoryTree];
}
