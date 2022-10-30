import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/model/chapter_model/chapter_model.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import 'editor_section/editor_section.dart';
import 'empty_section.dart';

class EditSection extends StatefulWidget {
  final GlobalService globalService;
  const EditSection({Key? key, required this.globalService}) : super(key: key);

  @override
  State<EditSection> createState() => _EditSectionState();
}

class _EditSectionState extends State<EditSection> {
  final unsubscribeCollect = UnsubscribeCollect([]);
  ChapterModel? chapter;

  @override
  void initState() {
    chapter = widget.globalService.chapterService.editChapterHook.value;
    unsubscribeCollect.addAll([
      widget.globalService.chapterService.editChapterHook.subscribe((data, _) {
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
    GlobalService globalService = RepositoryProvider.of<GlobalService>(context);
    final fullWidth = MediaQuery.of(context).size.width;
    final width = fullWidth - Config.lg1024DirectoryWidth - Config.lg1024CenterSectionWidth;
    return chapter == null ? EmptySection(width: width) : EditorSection(width: width, globalService: globalService);
  }
}
