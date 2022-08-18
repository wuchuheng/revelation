import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snotes/utils/logger.dart';

class EmptySection extends StatelessWidget {
  final double width;
  const EmptySection({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info(message: 'Build widget EmptySection', symbol: 'build');
    const String assetName = 'assets/images/svg/undraw_no_data_re_kwbl.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      semanticsLabel: 'Acme Logo',
      height: 50,
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: svg,
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Text(
              'No Data',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
