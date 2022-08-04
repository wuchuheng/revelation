abstract class CacheServiceAbstract {
  Future<String> get({required String key});

  Future<void> set({required String key, required String value});

  Future<void> unset({required String key});

  Future<bool> has({required String key});
}
