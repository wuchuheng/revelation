import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:revelation/global_states/authorization_bloc/authentication_bloc.dart';
import 'package:revelation/global_states/global_states.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../routes/route_path.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build Widget App', symbol: 'build');
    final child = route.build(
      debugShowCheckedModeBanner: false,
      context,
      title: 'Revelation',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF151026),
        ),
        primaryColor: HexColor('#4F23DA'),
      ),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DirectoryTreeBloc()),
        BlocProvider(create: (_) => AuthenticationBloc()),
      ],
      child: child,
    );
  }
}
