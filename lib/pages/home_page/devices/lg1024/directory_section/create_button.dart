import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/common/iconfont.dart';
import 'package:revelation/config/config.dart';
import 'package:revelation/service/global_service.dart';
import 'package:wuchuheng_logger/wuchuheng_logger.dart';

class CreateButton extends StatelessWidget {
  final double bottomBarHeight;

  const CreateButton({Key? key, required this.bottomBarHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Logger.info('Build widget CreateButton', symbol: 'build');
    final GlobalService globalService = RepositoryProvider.of<GlobalService>(context);

    return InkWell(
      onTap: globalService.directoryService.create,
      child: SizedBox(
        height: bottomBarHeight,
        width: double.infinity,
        child: Row(
          children: [
            Icon(IconFont.icon_plus, size: 13, color: Config.textGrey),
            Text(
              ' New Folder',
              style: TextStyle(color: Config.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}
