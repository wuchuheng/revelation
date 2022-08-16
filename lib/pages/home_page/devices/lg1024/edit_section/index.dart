import 'package:flutter/material.dart';
import 'package:snotes/config/config.dart';
import 'package:snotes/model/chapter_model/index.dart';
import 'package:snotes/pages/home_page/devices/lg1024/edit_section/empty_section.dart';
import 'package:snotes/service/chapter_service/index.dart';
import 'package:snotes/utils/subscription_builder/subscription_builder_abstract.dart';

class EditSection extends StatefulWidget {
  const EditSection({Key? key}) : super(key: key);

  @override
  State<EditSection> createState() => _EditSectionState();
}

class _EditSectionState extends State<EditSection> {
  final UnsubscribeCollect unsubscribeCollect = UnsubscribeCollect([]);
  ChapterModel? chapter = ChapterService.editChapterHook.value;
  final textEditingController = TextEditingController();

  @override
  void initState() {
    if (chapter != null) textEditingController.text = chapter!.content;
    unsubscribeCollect.addAll([
      ChapterService.editChapterHook.subscribe((data) {
        if (data?.id != chapter?.id) {
          setState(() => chapter = data);
          if (data != null) textEditingController.text = data.content;
        }
      }),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    unsubscribeCollect.unsubscribe();
    super.dispose();
  }

  onChanged(String value) async {
    chapter!.content = value;
    await ChapterService.update(chapter!);
  }

  @override
  Widget build(BuildContext context) {
    final fullWidth = MediaQuery.of(context).size.width;
    final width = fullWidth - Config.lg1024DirectoryWidth - Config.lg1024CenterSectionWidth;

    final edtor = SizedBox(
      height: MediaQuery.of(context).size.height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          autofocus: true,
          controller: textEditingController,
          onChanged: onChanged,
          maxLines: 200,
          decoration: const InputDecoration.collapsed(
            border: InputBorder.none,
            hintText: "",
          ),
        ),
      ),
    );

    return chapter == null ? EmptySection(width: width) : edtor;
  }
}
