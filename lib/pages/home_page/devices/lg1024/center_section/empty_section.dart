import 'package:flutter/material.dart';

class EmptySection extends StatelessWidget {
  const EmptySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
