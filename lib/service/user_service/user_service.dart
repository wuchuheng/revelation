import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:revelation/dao/user_dao/user_dao.dart';
import 'package:revelation/model/user_model/user_model.dart';
import 'package:revelation/routes/route_path.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../../pages/login_page/devices/form_section/account_info.dart';
import '../global_service.dart';

class UserService {
  final GlobalService _globalService;
  UserService({required GlobalService globalService}) : _globalService = globalService;

  UserModel? getUserInfo() => UserDao().has();

  void onConnect(AccountInfo accountInfo, BuildContext context) async {
    final cancel = BotToast.showLoading(); //popup a loading toast
    try {
      await _globalService.cacheService.connect(
        userName: accountInfo.userName,
        password: accountInfo.password,
        imapServerHost: accountInfo.host,
        imapServerPort: accountInfo.port,
        isImapServerSecure: accountInfo.tls,
      );
    } catch (e) {
      _globalService.cacheService.disconnect();
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
      host: accountInfo.host,
      port: accountInfo.port,
      tls: accountInfo.tls,
    );
    UserDao().save(user);
    pushHomePage(context);
  }

  void disconnect(BuildContext context) async {
    await _globalService.cacheService.disconnect();
    pushLoginPage(context);
  }
}
