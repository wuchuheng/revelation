import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../global_states/global_states.dart';
import '../routes/route_path.dart';

final themeData = ThemeData(
  appBarTheme: const AppBarTheme(
    color: Color(0xFF151026),
  ),
  primaryColor: HexColor('#4F23DA'),
);

class AppView extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  AppView({super.key});

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: (previous, current) {
        return true;
      },
      builder: (context, state) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
          theme: themeData,
          navigatorObservers: [BotToastNavigatorObserver()],
          builder: (context, child) {
            final blocChild = BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) => authenticationRouteGuard(context, state, _navigator),
              child: child,
            );
            return botToastBuilder(context, blocChild);
          },
          routes: routes,
          initialRoute: state.status == AuthenticationStatus.unknown ? '/loading' : null,
        );
      },
    );
  }
}
