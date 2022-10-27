import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/pages/home_page/devices/lg1024/center_section/center_section.dart';
import 'package:revelation/pages/home_page/devices/lg1024/directory_section/directory_section.dart';
import 'package:revelation/pages/home_page/devices/lg1024/edit_section/edit_section.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import 'float_buttons_section/float_buttons_section.dart';

class LG1024HomePage extends StatefulWidget {
  const LG1024HomePage({Key? key}) : super(key: key);

  @override
  State<LG1024HomePage> createState() => _LG1024HomePageState();
}

class _LG1024HomePageState extends State<LG1024HomePage> {
  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget LG1024HomePage', symbol: 'build');
    final GlobalService globalService = RepositoryProvider.of(context);
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TreeSection(
            globalService: globalService,
          ),
          CenterSection(
            globalService: globalService,
          ),
          EditSection(globalService: globalService),
        ],
      ),
      floatingActionButton: FloatButtonSection(globalService: globalService),
    );
  }
}
