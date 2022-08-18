import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snotes/utils/logger.dart';

import '../../../../../../../service/directory_service/index.dart';

class InputSection extends StatelessWidget {
  final void Function(String? value) onFieldSubmitted;
  final String? initialValue;
  const InputSection({
    Key? key,
    required this.onFieldSubmitted,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info(message: 'Build widget InputSection', symbol: 'build');
    return Container(
      height: 17.5,
      width: 200,
      margin: const EdgeInsets.only(left: 4),
      child: TextFormField(
        onChanged: DirectoryService.update,
        onFieldSubmitted: onFieldSubmitted,
        initialValue: initialValue,
        autofocus: true,
        cursorColor: Colors.grey[700],
        maxLines: 1,
        style: const TextStyle(fontSize: 10),
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          filled: true,
          border: OutlineInputBorder(borderSide: BorderSide.none),
          fillColor: Colors.white,
          contentPadding: EdgeInsets.only(left: 6),
          hintText: 'Folder Name',
        ),
      ),
    );
  }
}
