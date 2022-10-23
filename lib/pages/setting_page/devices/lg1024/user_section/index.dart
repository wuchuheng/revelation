import 'package:flutter/material.dart';
import 'package:revelation/model/user_model/user_model.dart';
import 'package:revelation/service/user_service/index.dart';

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
            ItemSection(label: 'Username', child: Text(userInfo!.userName)),
            ItemSection(
                label: 'Password', child: Text(List.generate(userInfo!.password.length, (index) => '*').join(''))),
            ItemSection(label: 'Host', child: Text(userInfo!.host)),
            ItemSection(label: 'Port', child: Text(userInfo!.port.toString())),
            ItemSection(label: 'TLS', child: Text(userInfo!.tls ? 'True' : 'False')),
            ItemSection(label: 'Status', child: const Text('Online')),
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
