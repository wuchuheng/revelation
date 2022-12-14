import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/service/global_service.dart';

import '../form_section/account_info.dart';
import '../form_section/form_section.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({Key? key}) : super(key: key);

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  onSubmit(AccountInfo accountInfo) => BotToast.showLoading(); //popup a loading toast

  @override
  Widget build(BuildContext context) {
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/svg/undraw_no_data_re_kwbl.svg',
                  semanticsLabel: 'Acme Logo',
                  width: 60,
                ),
                Text(
                  '  ${Config.appName}',
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            FormSection(
              onSubmit: (value) => globalService.userService.onConnect(value, context),
            ),
          ],
        ),
      ),
    );
  }
}
