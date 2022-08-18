import 'package:flutter/material.dart';
import 'package:snotes/utils/logger.dart';

class EmptySection extends StatelessWidget {
  const EmptySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info(message: 'Build widget EmptySection', symbol: 'build');
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Notes',
            style: TextStyle(color: Colors.grey[500]!),
          ),
        ],
      ),
    );
  }
}
