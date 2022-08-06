import 'package:snotes/service/cache_service/subscription/subscription_abstract.dart';

class Unsubscription implements UnsubscribeAbstract {
  final void Function() _unsubscribe;

  Unsubscription(this._unsubscribe);

  @override
  void unsubscribe() => _unsubscribe();
}