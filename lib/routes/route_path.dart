import 'package:flutter/cupertino.dart';
import 'package:revelation/pages/chapter_detail_page/chapter_detail_page.dart';
import 'package:revelation/pages/chapter_list_page/chapter_list_page.dart';
import 'package:revelation/pages/setting_page/setting_page.dart';

import '../global_states/authorization_bloc/authentication_bloc.dart';
import '../pages/home_page/home_page.dart';
import '../pages/loading_page/loading_page.dart';
import '../pages/login_page/login_page.dart';

pop(BuildContext context) => Navigator.of(context).pop();
pushHomePage(BuildContext context) => Navigator.of(context).pushAndRemoveUntil(HomePage.route(), (route) => false);
pushLoginPage(BuildContext context) => Navigator.of(context).pushAndRemoveUntil(LoginPage.route(), (route) => false);
pushSettingPage(BuildContext context) => Navigator.of(context).push(SettingPage.route());
pushChapterListPage(BuildContext context) => Navigator.of(context).push(ChapterListPage.route());
pushChapterDetailPage(BuildContext context) => Navigator.of(context).push(ChapterDetailPage.route());

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomePage(),
  '/loading': (context) => const LoadingPage(),
  '/detail': (context) => const ChapterDetailPage(),
};
void authenticationRouteGuard(BuildContext context, AuthenticationState state, NavigatorState navigator) {
  switch (state.status) {
    case AuthenticationStatus.unknown:
      break;
    case AuthenticationStatus.authenticated:
      navigator.pushAndRemoveUntil<void>(HomePage.route(), (route) => false);
      break;
    case AuthenticationStatus.unauthenticated:
      navigator.pushAndRemoveUntil<void>(LoginPage.route(), (route) => false);
      break;
  }
}
