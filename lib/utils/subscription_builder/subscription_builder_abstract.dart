import 'package:snotes/utils/subscription_builder/unsubscription_builder.dart';

class Unsubscribe implements UnsubscribeAbstract {
  final bool Function() callback;

  Unsubscribe(this.callback);

  @override
  bool unsubscribe() => callback();
}

class Subscription<T> {
  Map<int, Function(T data)> _idMapcallback = {};
  @override
  Subscription<T> next(T data) {
    _idMapcallback.forEach((_, callback) => callback(data));
    return this;
  }

  Unsubscribe subscribe(Function(T data) callback) {
    int id = DateTime.now().microsecondsSinceEpoch;
    _idMapcallback[id] = callback;
    return Unsubscribe(() {
      if (_idMapcallback[id] != null) {
        _idMapcallback.remove(id);
        return true;
      }
      return false;
    });
  }
}

class SubscriptionBuilder {
  static Subscription<T> builder<T>() {
    return Subscription<T>();
  }
}

class UnsubscribeCollect implements UnsubscribeCollectAbstract {
  final List<UnsubscribeAbstract> unsubscribeList;

  UnsubscribeCollect(this.unsubscribeList);

  @override
  void unsubscribe() {
    for (var element in unsubscribeList) {
      element.unsubscribe();
    }
  }

  @override
  void add(UnsubscribeAbstract unsubscribeAbstract) {
    unsubscribeList.add(unsubscribeAbstract);
  }

  @override
  void addAll(Iterable<UnsubscribeAbstract> unsubscribeAbstract) {
    unsubscribeList.addAll(unsubscribeAbstract);
  }
}
