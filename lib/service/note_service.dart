import 'package:snotes/service/cache_service.dart';

import 'directory_tree_service/directory_tree_service.dart';

class NoteService {
  createFold(String fold) async {
    if (!CacheService.isLogin()) {
      await CacheService.login(
        userName: '2831473954@qq.com',
        password: 'owtdtjnltfnndegh',
        imapServerHost: 'local.wuchuheng.com',
        imapServerPort: 993,
        isImapServerSecure: true,
        boxName: 'snotes',
        syncIntervalSeconds: 5,
        isShowLog: true,
      );
    }
    DirectoryTreeService.init();
    DirectoryTreeService.create(
      title: "All",
      pid: 0,
      sortId: 0,
    );
  }
}
