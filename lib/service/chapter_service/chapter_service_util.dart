class ChapterServiceUtil {
  final String _cachePrefix = 'chapter_item_';
  String getCacheKeyById(int id) {
    return '${_cachePrefix}_$id';
  }

  bool isChapterByCacheKey(String key) {
    if (key.length < _cachePrefix.length) {
      return false;
    }
    return key.substring(0, _cachePrefix.length) == _cachePrefix;
  }
}
