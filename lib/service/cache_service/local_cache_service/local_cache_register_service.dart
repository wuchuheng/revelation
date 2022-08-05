import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:snotes/service/cache_service/cache_io_abstract.dart';
import 'package:snotes/service/cache_service/utils/single_task_pool.dart';
import '../imap_service/register_service_abstract.dart';

/// 本地缓存注册表
class LocalCacheRegisterService implements RegisterServiceAbstract {
  static RegisterInfo? _data;
  static SingleTaskPool singleTaskPool = SingleTaskPool.builder();

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/cache/register';
    String filePath = '$path/register.json';
    File file = File(filePath);
    if (!await file.exists()) {
      if (!await Directory(path).exists()) {
        await Directory(path).create(recursive: true);
      }
      String registerJson = jsonEncode(RegisterInfo(data: {}, uidMapKey: {}));
      await file.writeAsString(registerJson);
    }

    return file;
  }

  @override
  Future<RegisterInfo> getRegister() async {
    Completer<RegisterInfo> completer = Completer();
    await singleTaskPool.start(() async {
      if (_data == null) {
        File file = await _getFile();
        final String contents = await file.readAsString();
        _data = RegisterInfo.fromJson(jsonDecode(contents));
      }
      completer.complete(_data!);
    });

    return completer.future;
  }

  @override
  Future<bool> hasRegister() async {
    return true;
  }

  @override
  Future<void> setRegister({required RegisterInfo data}) async {
    await singleTaskPool.start(() async {
      final String registerJson = jsonEncode(data);
      File file = await _getFile();
      file.writeAsStringSync(registerJson);
      _data = data;
    });
  }
}
