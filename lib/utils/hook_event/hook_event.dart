import '../subscription_builder/subscription_builder_abstract.dart';

class Hook<T> {
  T value;
  Hook(this.value);
  final Subscription<T> _onEvent = SubscriptionBuilder.builder();

  void set(T newData) {
    value = newData;
    _onEvent.next(value);
  }

  void setCallback(T Function(T data) callback) {
    value = callback(value);
    _onEvent.next(value);
  }

  Unsubscribe subscribe(void Function(T data) callback) => _onEvent.subscribe(callback);
}
