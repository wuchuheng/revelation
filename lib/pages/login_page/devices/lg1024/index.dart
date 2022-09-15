import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:snotes/service/user_service/index.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

import '../form_section/index.dart';
import 'banner_section/index.dart';

class Lg1024LoginPage extends StatefulWidget {
  const Lg1024LoginPage({Key? key}) : super(key: key);

  @override
  State<Lg1024LoginPage> createState() => _Lg1024LoginPageState();
}

class _Lg1024LoginPageState extends State<Lg1024LoginPage> {
  bool isLoading = false;

  Widget getLoadingSpinner() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(196, 196, 196, 1.0).withOpacity(0.7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitPouringHourGlass(color: Colors.grey[800]!),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Loading...'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget LoginPage', symbol: 'build');
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: HexColor('#EBE7E9'),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const BannerSection(),
                SizedBox(
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormSection(onSubmit: (account) => UserService.onConnect(account, context)),
                    ],
                  ),
                ),
              ],
            ),
            if (isLoading) getLoadingSpinner(),
          ],
        ),
      ),
    );
  }
}
