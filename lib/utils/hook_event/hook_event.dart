import '../subscription_builder/subscription_builder_abstract.dart';

class HookImp<T> {
  T value;
  final Subscription<T> _onEvent = SubscriptionBuilder.builder();
  HookImp(this.value);

  void set(T newData) {
    value = newData;
    _onEvent.next(value);
  }

  void setCallback(T Function(T data) callback) {
    value = callback(value);
    _onEvent.next(value);
  }

  Unsubscrible subscribe(void Function(T data) callback) => _onEvent.subscribe(callback);
}

class Hook {
  static HookImp<T> builder<T>(T data) {
    return HookImp<T>(data);
  }
}
