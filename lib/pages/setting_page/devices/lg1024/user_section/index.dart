import 'package:flutter/material.dart';
import 'package:snotes/model/user_model/user_model.dart';
import 'package:snotes/service/user_service/index.dart';

import 'item_section.dart';

class UserSection extends StatefulWidget {
  const UserSection({Key? key}) : super(key: key);

  @override
  State<UserSection> createState() => _UserSectionState();
}

class _UserSectionState extends State<UserSection> {
  UserModel? userInfo;

  @override
  void initState() {
    userInfo = UserService.getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userInfo == null) return Container();

    return Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 400,
        height: 350,
        child: Column(
          children: [
            ItemSection(label: 'Username', value: userInfo!.userName),
            ItemSection(label: 'Password', value: userInfo!.password, isPassword: true),
            ItemSection(label: 'Host', value: userInfo!.imapServerHost),
            ItemSection(label: 'Port', value: userInfo!.imapServerPort.toString()),
            ItemSection(label: 'TLS', value: userInfo!.isImapServerSecure ? 'True' : 'False'),
            ItemSection(label: 'Status', value: 'Online'),
            Container(
              margin: const EdgeInsets.only(top: 30),
              width: 200,
              height: 35,
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: UserService.disconnect,
                child: const Text('Disconnect'),
              ),
            )
          ],
        ));
  }
}
