import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:snotes/model/user_account_model/user_account_model.dart';
import 'package:snotes/pages/login_page/form_section/account_info.dart';
import 'package:snotes/pages/login_page/form_section/index.dart';

import '../../routes/route_path.dart';
import '../../service/cache_service.dart';

class LoginPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const _LoginPage();
      },
    );
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage({Key? key}) : super(key: key);

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  bool isLoading = false;
  handleSubmit(AccountInfo accountInfo, BuildContext context) async {
    setState(() => isLoading = true);
    try {
      await CacheService.login(
        userName: accountInfo.userName,
        password: accountInfo.password,
        imapServerHost: accountInfo.host,
        imapServerPort: accountInfo.port,
        isImapServerSecure: accountInfo.tls,
      );
    } catch (e, stack) {
      final snackBar = SnackBar(
        content: const Text('Failed to connect to IMAP server.'),
        backgroundColor: Colors.red[300],
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() => isLoading = false);
    UserAccountModel userAccountModel = UserAccountModel(
      userName: accountInfo.userName,
      password: accountInfo.password,
      imapServerHost: accountInfo.host,
      imapServerPort: accountInfo.port,
      isImapServerSecure: accountInfo.tls,
    );
    await UserAccountModel.save(userAccountModel);

    RoutePath.pushHomePage();
  }

  Widget getLoadingSpinner() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(196, 196, 196, 1.0).withOpacity(0.7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitPouringHourGlass(color: Colors.grey[800]!),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Loading...'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor('#EBE7E9'),
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 320,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormSection(onSubmit: (account) => handleSubmit(account, context)),
                  ],
                ),
              ),
            ),
            if (isLoading) getLoadingSpinner(),
          ],
        ),
      ),
    );
  }
}