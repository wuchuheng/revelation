import 'package:flutter/material.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/model/chapter_model/index.dart';
import 'package:snotes/service/chapter_service/index.dart';
import 'package:snotes/utils/subscription_builder/subscription_builder_abstract.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import 'editor_section/index.dart';
import 'empty_section.dart';

class EditSection extends StatefulWidget {
  const EditSection({Key? key}) : super(key: key);

  @override
  State<EditSection> createState() => _EditSectionState();
}

class _EditSectionState extends State<EditSection> {
  final unsubscribeCollect = UnsubscribeCollect([]);
  ChapterModel? chapter = ChapterService.editChapterHook.value;

  @override
  void initState() {
    unsubscribeCollect.addAll([
      ChapterService.editChapterHook.subscribe((data) {
        if (data?.id != chapter?.id) setState(() => chapter = data);
      }),
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
    Logger.info('Build widget EditSection', symbol: 'build');
    final fullWidth = MediaQuery.of(context).size.width;
    final width = fullWidth - Config.lg1024DirectoryWidth - Config.lg1024CenterSectionWidth;
    return chapter == null ? EmptySection(width: width) : EditorSection(width: width);
  }
}
