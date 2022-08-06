import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:snotes/service/cache_service/errors/key_not_found_error.dart';
import 'package:snotes/service/cache_service/local_cache_service/local_cache_register_service.dart';
import 'package:snotes/service/cache_service/utils/logger.dart';

import '../cache_io_abstract.dart';
import '../cache_service_abstract.dart';
import '../utils/hash.dart';

class LocalCacheService implements CacheServiceAbstract {
  Future<String> get _path async {
    final directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/cache/data';
    if (!await Directory(path).exists()) {
      await Directory(path).create(recursive: true);
    }
    return path;
  }

  @override
  Future<String> get({required String key}) async {
    if (!await has(key: key)) throw KeyNotFoundError();
    String path = await _path;
    String filePath = '$path/$key.json';

    return File(filePath).readAsStringSync();
  }

  @override
  Future<bool> has({required String key}) async {
    RegisterInfo registerInfo = await LocalCacheRegisterService().getRegister();
    return registerInfo.data.containsKey(key) &&
        registerInfo.data[key]!.deletedAt == null;
  }

  @override
  Future<void> set({required String key, required String value}) async {
    Logger.info('Start setting up local cache. key: $key value: $value');
    String path = await _path;
    String filePath = '$path/$key.json';
    File file = File(filePath);
    await file.writeAsString(value);
    Logger.info('Successfully put $key in $filePath.');
    RegisterInfo registerData = await LocalCacheRegisterService().getRegister();
    registerData.data[key] = RegisterItemInfo(
      lastUpdatedAt: DateTime.now().toString(),
      uid: 0,
      hash: Hash.convertStringToHash(value),
    );
    LocalCacheRegisterService().setRegister(data: registerData);
    Logger.info('Complete local cache settings. key $key value: $value');
  }

  @override
  Future<void> unset({required String key}) async {
    if (!await has(key: key)) {
      Logger.error('Not Found key: $key');
      throw KeyNotFoundError();
    }
    RegisterInfo registerInfo = await LocalCacheRegisterService().getRegister();
    registerInfo.data[key]!.deletedAt = DateTime.now().toString();
    await LocalCacheRegisterService().setRegister(data: registerInfo);
  }
}
