import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class EmptySection extends StatelessWidget {
  const EmptySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget EmptySection', symbol: 'build');
    const String assetName = 'assets/images/svg/undraw_no_data_re_kwbl.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      height: 110,
    );

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: svg,
          ),
          Text(
            'No Data',
            style: TextStyle(color: Colors.grey[500]!),
          ),
        ],
      ),
    );
  }
}
