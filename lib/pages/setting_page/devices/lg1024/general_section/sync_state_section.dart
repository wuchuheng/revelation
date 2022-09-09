import 'package:flutter/material.dart';

class SyncStateSection extends StatefulWidget {
  const SyncStateSection({Key? key}) : super(key: key);

  @override
  State<SyncStateSection> createState() => _SyncStateSectionState();
}

class _SyncStateSectionState extends State<SyncStateSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
