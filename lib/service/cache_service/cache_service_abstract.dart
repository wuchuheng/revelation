abstract class CacheServiceAbstract {
  Future<String> get({required String key});

  Future<void> set({required String name, required String content});

  Future<void> unset({required String name});

  Future<bool> has({required String name});
}
