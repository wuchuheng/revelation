import '../cache_io_abstract.dart';

abstract class RegisterServiceAbstract {
  /// 有没有注册表
  Future<RegisterInfo?> hasRegister();

  /// 初始化注册表
  Future<void> setRegister({required RegisterInfo data});

  /// 获取注册表
  Future<RegisterInfo> getRegister();
}
