abstract class UnsubscribeAbstract {
  bool unsubscribe();
}

abstract class UnsubscribeCollectAbstract {
  void add(UnsubscribeAbstract unsubscribeAbstract);
  void addAll(Iterable<UnsubscribeAbstract> unsubscribeAbstract);
  void unsubscribe();
}
