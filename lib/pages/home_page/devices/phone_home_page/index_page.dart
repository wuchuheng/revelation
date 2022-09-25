import 'package:flutter/material.dart';
import 'package:revelation/common/phone_body_container/index.dart';
import 'package:revelation/layout/phone_scaffold/index.dart';

import '../../../../common/phone_large_title_layout_container/index.dart';
import 'directory_section/index.dart';

class PhoneHomePage extends StatefulWidget {
  const PhoneHomePage({Key? key}) : super(key: key);

  @override
  State<PhoneHomePage> createState() => _PhoneHomePageState();
}

class _PhoneHomePageState extends State<PhoneHomePage> {
  @override
  Widget build(BuildContext context) {
    return const PhoneScaffoldLayout(
      body: PhoneBodyContainer(
        child: PhoneLargeTitleLayoutContainer(
          title: 'Folders',
          children: [
            DirectorySection(),
          ],
        ),
      ),
    );
  }
}
