import 'package:snotes/utils/subscription_builder/subscription_builder.dart';

class Unsubscrible implements UnsubscribeAbstract {
  final bool Function() callback;

  Unsubscrible(this.callback);

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

  Unsubscrible subscribe(Function(T data) callback) {
    int id = DateTime.now().microsecondsSinceEpoch;
    _idMapcallback[id] = callback;
    return Unsubscrible(() {
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
