abstract class CacheServiceAbstract {
  Future<String> get({required String key});

  Future<void> set({required String key, required String value});

  Future<void> unset({required String key});

  // todo 这里的Future<bool> --> Future<String>
  Future<bool> has({required String key});
}
