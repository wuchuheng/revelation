import 'package:flutter/material.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/model/chapter_model/index.dart';
import 'package:snotes/pages/home_page/devices/lg1024/edit_section/editor_section.dart';
import 'package:snotes/pages/home_page/devices/lg1024/edit_section/empty_section.dart';
import 'package:snotes/service/chapter_service/index.dart';
import 'package:snotes/utils/subscription_builder/subscription_builder_abstract.dart';

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
    super.initState();
    unsubscribeCollect.addAll([
      ChapterService.editChapterHook.subscribe((data) {
        setState(() => chapter = data);
      }),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    final width = fullWidth - Config.lg1024DirectoryWidth - Config.lg1024CenterSectionWidth;
    return chapter == null ? EmptySection(width: width) : EditorSection(width: width);
  }
}
