class ChapterServiceUtil {
  static const String _cachePrefix = 'chapter_item_';
  static String getCacheKeyById(int id) {
    return '${_cachePrefix}_$id';
  }

  static bool isChapterByCacheKey(String key) {
    if (key.length < _cachePrefix.length) {
      return false;
    }
    return key.substring(0, _cachePrefix.length) == _cachePrefix;
  }
}
