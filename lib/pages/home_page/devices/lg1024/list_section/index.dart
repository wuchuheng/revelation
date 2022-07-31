import 'package:flutter/material.dart';
import 'package:smtpnotes/pages/common_config.dart';

class ListSection extends StatefulWidget {
  const ListSection({Key? key}) : super(key: key);

  @override
  State<ListSection> createState() => _ListSectionState();
}

class _ListSectionState extends State<ListSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: CommonConfig.lg1024ListWidth,
      height: MediaQuery.of(context).size.height - CommonConfig.toolBarHeight,
      color: Colors.white,
    );
  }
}
