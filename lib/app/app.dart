import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/app/app_view.dart';
import 'package:revelation/global_states/authorization_bloc/authentication_bloc.dart';
import 'package:revelation/global_states/global_states.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build Widget App', symbol: 'build');

    GlobalService globalService = GlobalService();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GlobalService>(create: (context) => globalService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => DirectoryTreeBloc()),
          BlocProvider(
            lazy: true,
            create: (_) => AuthenticationBloc(cacheService: globalService.cacheService)
              ..add(
                AuthenticationAutoLoginRequested(),
              ),
          ),
        ],
        child: AppView(globalService: globalService),
      ),
    );
  }
}
