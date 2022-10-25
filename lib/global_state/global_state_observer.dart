import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalStateObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    print('${bloc.runtimeType} $change');
    super.onChange(bloc, change);
  }
}
