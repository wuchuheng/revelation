import 'package:snotes/service/cache_service/cache_service.dart';

class NoteService {
  Future<void> createFold(String fold) async {
    final cacheServiceInstance = await CacheService.getInstance();
    await cacheServiceInstance.set(
        name: 'tmp', content: '{"id": "replay", "pid": 1312312312}');
    await cacheServiceInstance.set(
        name: 'tmptmp', content: '{"id": "replay", "pid": 212312312}');
    // await ImapService().unset(name: 'tmp');
    // await ImapService().get(name: 'tmp');
  }
}
