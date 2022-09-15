import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:snotes/dao/user_dao/index.dart';
import 'package:snotes/model/user_model/user_model.dart';
import 'package:snotes/routes/route_path.dart';
import 'package:snotes/service/cache_service.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../pages/login_page/devices/form_section/account_info.dart';

class UserService {
  static UserModel? getUserInfo() => UserDao().has();

  static void onConnect(AccountInfo accountInfo, BuildContext context) async {
    final cancel = BotToast.showLoading(); //popup a loading toast
    try {
      await CacheService.connect(
        userName: accountInfo.userName,
        password: accountInfo.password,
        imapServerHost: accountInfo.host,
        imapServerPort: accountInfo.port,
        isImapServerSecure: accountInfo.tls,
      );
    } catch (e) {
      Logger.error(e.toString(), symbol: 'imap');
      final snackBar = SnackBar(
        content: const Text('Failed to connect to IMAP server.'),
        backgroundColor: Colors.red[300],
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      cancel();
      return;
    }
    cancel();
    UserModel user = UserModel(
      userName: accountInfo.userName,
      password: accountInfo.password,
      imapServerHost: accountInfo.host,
      imapServerPort: accountInfo.port,
      isImapServerSecure: accountInfo.tls,
    );
    UserDao().save(user);
    RoutePath.pushHomePage();
  }

  static void disconnect() async {
    await CacheService.disconnect();
    RoutePath.isSQLLiteInit = false;
    RoutePath.pushLoginPage();
  }
}
