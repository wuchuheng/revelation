import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/app/app_view.dart';
import 'package:revelation/global_states/authorization_bloc/authentication_bloc.dart';
import 'package:revelation/global_states/global_states.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build Widget App', symbol: 'build');

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DirectoryTreeBloc()),
        BlocProvider(lazy: true, create: (_) => AuthenticationBloc()..add(AuthenticationAutoLoginRequested())),
      ],
      child: AppView(),
    );
  }
}
