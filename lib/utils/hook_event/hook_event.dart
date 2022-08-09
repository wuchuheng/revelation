import '../subscription_builder/subscription_builder_abstract.dart';

class Hook<T> {
  T data;
  final Subscription<T> _onEvent = SubscriptionBuilder.builder();
  Hook(this.data);

  void set(T newData) {
    data = newData;
    _onEvent.next(data);
  }

  void setCallback(T Function(T data) callback) {
    T newData = callback(data);
    _onEvent.next(newData);
  }

  Unsubscrible subscribe(void Function(T data) callback) => _onEvent.subscribe(callback);
}

class HookEvent {
  static Hook<T> builder<T>(T data) {
    return Hook<T>(data);
  }
}
