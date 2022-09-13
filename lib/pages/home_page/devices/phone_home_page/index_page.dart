import 'package:flutter/material.dart';
import 'package:snotes/common/phone_body_container/index.dart';
import 'package:snotes/common/phone_layout_container/index.dart';
import 'package:snotes/pages/home_page/devices/phone_home_page/directory_section/index.dart';

class PhoneHomePage extends StatefulWidget {
  const PhoneHomePage({Key? key}) : super(key: key);

  @override
  State<PhoneHomePage> createState() => _PhoneHomePageState();
}

class _PhoneHomePageState extends State<PhoneHomePage> {
  @override
  Widget build(BuildContext context) {
    final topHeight = MediaQuery.of(context).viewPadding.top;
    final height = MediaQuery.of(context).size.height;

    return const Scaffold(
      body: PhoneBodyContainer(
        child: PhoneLayoutContainer(
          children: [
            DirectorySection(),
          ],
        ),
      ),
    );
  }
}
