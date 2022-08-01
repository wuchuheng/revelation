import 'package:flutter/material.dart';
import 'package:snotes/pages/common_config.dart';

class EditSection extends StatefulWidget {
  const EditSection({Key? key}) : super(key: key);

  @override
  State<EditSection> createState() => _EditSectionState();
}

class _EditSectionState extends State<EditSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - CommonConfig.toolBarHeight,
      color: Colors.blue[100],
      width: MediaQuery.of(context).size.width -
          CommonConfig.lg1024DirectoryWidth -
          CommonConfig.lg1024ListWidth,
      child: const TextField(
        maxLines: 200,
        decoration: InputDecoration.collapsed(
          border: InputBorder.none,
          hintText: "",
        ),
      ),
    );
  }
}
