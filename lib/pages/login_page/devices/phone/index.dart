import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:revelation/service/user_service/index.dart';

import '../form_section/account_info.dart';
import '../form_section/index.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({Key? key}) : super(key: key);

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  onSubmit(AccountInfo accountInfo) {
    final cancel = BotToast.showLoading(); //popup a loading toast
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.only(top: 70),
          child: FormSection(
            onSubmit: (value) => UserService.onConnect(value, context),
          ),
        ),
      ),
    );
  }
}
