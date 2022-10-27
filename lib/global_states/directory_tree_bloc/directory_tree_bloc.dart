import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dao/directory_dao/directory_dao.dart';
import '../../model/directory_model/directory_model.dart';

part 'directory_tree_event.dart';
part 'directory_tree_state.dart';

class DirectoryTreeBloc extends Bloc<DirectoryTreeEvent, DirectoryTreeState> {
  ///  Change directory tree event.
  Future<void> _onDirectoryTreeChanged(DirectoryTreeChanged event, Emitter<DirectoryTreeState> emit) async {
    final directoryData = DirectoryDao().fetchAll();
    final directoryTree = _idMapTreeItemConvertToTree(directoryData);
    emit(DirectoryTreeState.directoryTreeChanged(directoryTree: directoryTree));
  }

  List<DirectoryModel> _idMapTreeItemConvertToTree(List<DirectoryModel> directories) {
    Map<int, DirectoryModel> idMapTreeItem = {};
    List<DirectoryModel> result = [];
    for (final value in directories) {
      if (value.deletedAt == null) {
        idMapTreeItem[value.id] = value;
        if (value.pid == 0) {
          result.add(idMapTreeItem[value.id]!);
        } else if (idMapTreeItem.containsKey(value.pid)) {
          idMapTreeItem[value.pid]!.children.add(value);
        }
      }
    }

    return result;
  }

  DirectoryTreeBloc() : super(const DirectoryTreeState.init()) {
    on<DirectoryTreeChanged>(_onDirectoryTreeChanged);
  }
}
