import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/config.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({Key? key}) : super(key: key);

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/images/svg/undraw_notebook_re_id0r.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      semanticsLabel: 'Acme Logo',
      height: 170,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        svg,
        const Padding(padding: EdgeInsets.only(top: 30)),
        Text(
          Config.appName,
          style: const TextStyle(fontSize: 30),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        const Text('A note based on the imap protocol.'),
      ],
    );
  }
}
