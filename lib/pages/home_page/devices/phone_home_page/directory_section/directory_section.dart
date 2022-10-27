import 'package:flutter/material.dart';
import 'package:revelation/service/directory_service/directory_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

import 'item_section.dart';

class DirectorySection extends StatefulWidget {
  const DirectorySection({Key? key}) : super(key: key);

  @override
  State<DirectorySection> createState() => _DirectorySectionState();
}

class _DirectorySectionState extends State<DirectorySection> {
  UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);

  @override
  void initState() {
    unsubscribeCollect = UnsubscribeCollect([DirectoryService.directoryHook.subscribe((value) => setState(() {}))]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final directory = DirectoryService.directoryHook.value;
    print(directory);

    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: directory
            .map(
              (e) => ItemSection(directory: e),
            )
            .toList(),
      ),
    );
  }
}
