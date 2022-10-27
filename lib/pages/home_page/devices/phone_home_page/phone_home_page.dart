import 'package:flutter/material.dart';
import 'package:revelation/common/phone_body_container/phone_body_container.dart';
import 'package:revelation/layout/phone_scaffold/phone_scaffold.dart';

import '../../../../common/phone_large_title_layout_container/phone_large_title_layout_container.dart';
import 'directory_section/directory_section.dart';

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
