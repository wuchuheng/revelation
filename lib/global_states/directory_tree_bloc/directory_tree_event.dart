part of 'directory_tree_bloc.dart';

abstract class DirectoryTreeEvent extends Equatable {
  const DirectoryTreeEvent();

  @override
  List<Object> get props => [];
}

/// Change directory tree event.
class DirectoryTreeChanged extends DirectoryTreeEvent {}
