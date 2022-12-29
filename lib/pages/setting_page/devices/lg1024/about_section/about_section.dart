import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:revelation/config/config.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  String version = '';

  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/images/svg/undraw_no_data_re_kwbl.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      height: 110,
    );
    Widget container(Widget child) => Container(margin: const EdgeInsets.only(top: 10), child: child);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        svg,
        container(Text(
          Config.appName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        )),
        container(Text('Version $version')),
        container(const Text('Developer: wuchuheng<root@wuchuheng.com>')),
        container(const Text('Official website: https://wuchuheng.com/revelation/')),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Text(
            'Copyright © 2022 com.wuchuheng.revelation. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[400]!),
          ),
        ),
      ],
    );
  }
}
