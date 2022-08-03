import 'package:snotes/service/cache_service/cache_service_abstract.dart';

abstract class CacheIOAbstract extends CacheServiceAbstract {
  /// 有没有注册表
  Future<bool> hasRegister();

  /// 初始化注册表
  Future<void> setRegister({required String data});
}
