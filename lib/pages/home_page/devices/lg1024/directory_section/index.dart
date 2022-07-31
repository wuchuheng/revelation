import 'package:flutter/material.dart';
import 'package:smtpnotes/pages/common_config.dart';
import 'package:smtpnotes/pages/home_page/devices/lg1024/directory_section/item_section.dart';

class DirectorySection extends StatefulWidget {
  const DirectorySection({Key? key}) : super(key: key);

  @override
  State<DirectorySection> createState() => _DirectorySectionState();
}

class _DirectorySectionState extends State<DirectorySection> {
  @override
  Widget build(BuildContext context) {
    double LRMargin = 10;
    return Container(
      color: Colors.green[100],
      width: CommonConfig.lg1024DirectoryWidth,
      padding: EdgeInsets.only(left: LRMargin, right: LRMargin),
      height: MediaQuery.of(context).size.height,
      child: const ItemSection(),
    );
  }
}
