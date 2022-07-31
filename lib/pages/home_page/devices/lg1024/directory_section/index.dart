import 'package:flutter/material.dart';
import 'package:smtpnotes/model/directory_model.dart';
import 'package:smtpnotes/pages/common_config.dart';
import 'package:smtpnotes/pages/home_page/devices/lg1024/directory_section/create_button.dart';
import 'package:smtpnotes/pages/home_page/devices/lg1024/directory_section/item_section.dart';

class DirectorySection extends StatefulWidget {
  const DirectorySection({Key? key}) : super(key: key);

  @override
  State<DirectorySection> createState() => _DirectorySectionState();
}

class _DirectorySectionState extends State<DirectorySection> {
  int _activeId = 1;

  @override
  Widget build(BuildContext context) {
    DirectoryModel data =
        DirectoryModel(id: 1, title: "All", count: 10, children: [
      DirectoryModel(
        id: 2,
        title: '1',
        count: 2,
        children: [
          DirectoryModel(id: 3, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 4, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 5, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 6, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 7, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 8, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 9, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 10, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 11, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 12, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 13, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 14, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 15, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 16, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 17, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 18, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 19, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 20, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 21, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 22, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 23, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 24, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 25, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 26, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 27, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 28, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 29, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 30, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 31, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 32, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 33, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 34, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 35, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 36, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 37, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 38, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 39, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 40, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 41, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 42, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 43, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 44, title: '1-1', count: 2, children: []),
          DirectoryModel(id: 45, title: '1-1', count: 2, children: []),
        ],
      ),
      DirectoryModel(id: 4, title: '2', count: 2, children: [])
    ]);
    double LRMargin = 10;
    const double bottomBarHeight = 40;
    final list = Container(
      height: MediaQuery.of(context).size.height - bottomBarHeight,
      child: SingleChildScrollView(
        child: ItemSection(
            key: ValueKey(data.id),
            data: data,
            activeId: _activeId,
            onChange: (int newActiveId) => setState(
                  () => _activeId = newActiveId,
                )),
      ),
    );

    return Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.green[100],
        width: CommonConfig.lg1024DirectoryWidth,
        padding: EdgeInsets.only(left: LRMargin, right: LRMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            list,
            const CreateButton(bottomBarHeight: bottomBarHeight),
          ],
        ));
  }
}
