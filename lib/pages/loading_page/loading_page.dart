import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const LoadingPage());

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/images/svg/undraw_floating_re_xtcj.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      semanticsLabel: 'Acme Logo',
      width: 300,
    );
    final child = Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          svg,
          const Padding(padding: EdgeInsets.only(top: 40)),
          const Text(
            'Loading...',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
          ),
        ],
      ),
    );

    return Scaffold(body: child);
  }
}
