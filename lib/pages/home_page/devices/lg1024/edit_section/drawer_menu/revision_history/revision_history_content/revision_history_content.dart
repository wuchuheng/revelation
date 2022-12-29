import 'package:flutter/material.dart';
import 'package:revelation/model/history_chapter_model/history_chapter_model.dart';

class RevisionHistoryContent extends StatefulWidget {
  HistoryChapterModel historyChapter;
  RevisionHistoryContent({Key? key, required this.historyChapter}) : super(key: key);

  @override
  State<RevisionHistoryContent> createState() => _RevisionHistoryContentState();
}

class _RevisionHistoryContentState extends State<RevisionHistoryContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.historyChapter.title),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            child: Text(widget.historyChapter.content),
          ),
        ),
      ],
    );
  }
}
