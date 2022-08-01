import 'package:snotes/service/imap_service.dart';

class NoteService {
  Future<void> createFold(String fold) async {
    await ImapService()
        .set(name: 'tmp', content: '{"id": "replay", "pid": 1312312312}');
    await ImapService()
        .set(name: 'tmptmp', content: '{"id": "replay", "pid": 212312312}');
    // await ImapService().unset(name: 'tmp');
    // await ImapService().get(name: 'tmp');
  }
}
