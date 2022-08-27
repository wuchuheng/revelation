import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _LoadingPage(),
    );
  }
}

class _LoadingPage extends StatefulWidget {
  const _LoadingPage({Key? key}) : super(key: key);

  @override
  State<_LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<_LoadingPage> {
  String path = '';

  @override
  void initState() {
    getApplicationDocumentsDirectory().then((value) => setState(() => path = value.path));
  }

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/images/svg/undraw_no_data_re_kwbl.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      semanticsLabel: 'Acme Logo',
      width: 100,
    );
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          svg,
          const Padding(padding: EdgeInsets.only(top: 20)),
          Text(path, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
