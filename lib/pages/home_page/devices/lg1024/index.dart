import 'package:flutter/material.dart';
import 'package:smtpnotes/pages/home_page/devices/lg1024/components/list_and_edit_container.dart';
import 'package:smtpnotes/pages/home_page/devices/lg1024/components/tool_bar_list_edit_container.dart';
import 'package:smtpnotes/pages/home_page/devices/lg1024/directory_section/index.dart';
import 'package:smtpnotes/pages/home_page/devices/lg1024/edit_section/index.dart';
import 'package:smtpnotes/pages/home_page/devices/lg1024/list_section/index.dart';
import 'package:smtpnotes/pages/home_page/devices/lg1024/tool_bar_section.dart';

class LG1024HomePage extends StatefulWidget {
  const LG1024HomePage({Key? key}) : super(key: key);

  @override
  State<LG1024HomePage> createState() => _LG1024HomePageState();
}

class _LG1024HomePageState extends State<LG1024HomePage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        DirectorySection(),
        ToolBarListEditContainer(
          children: [
            ToolBarSection(),
            ListAndEditContainer(
              children: [
                ListSection(),
                EditSection(),
              ],
            )
          ],
        )
      ],
    );
  }
}
