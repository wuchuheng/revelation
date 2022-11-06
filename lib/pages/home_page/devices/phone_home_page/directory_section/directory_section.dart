import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:revelation/model/directory_model/directory_model.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import 'item_section.dart';

class DirectorySection extends StatefulWidget {
  final GlobalService globalService;
  const DirectorySection({Key? key, required this.globalService}) : super(key: key);

  @override
  State<DirectorySection> createState() => _DirectorySectionState();
}

class _DirectorySectionState extends State<DirectorySection> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  List<DirectoryModel> treeItems = [];

  @override
  void initState() {
    treeItems = widget.globalService.directoryService.directoryHook.value;
    unsubscribeCollect = UnsubscribeCollect([
      widget.globalService.directoryService.directoryHook.subscribe((value, _) => setState(() {})),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        for (var item in treeItems) ItemSection(directory: item, key: ValueKey(item.id)),
      ]),
    );
  }
}
