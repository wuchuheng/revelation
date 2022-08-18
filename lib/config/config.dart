import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Config {
  static final Color textGrey = Colors.grey[700]!;
  static final Color activeColor = HexColor('#E4C65E');
  static final Color activeBorderColor = HexColor('#DC9607');
  static final Color primaryColor = HexColor('#DC9607');
  static final Color backgroundColor = HexColor('#E3DEE2');
  static Color borderColor = Colors.grey[350]!;
  static Color iconColor = Colors.grey[600]!;

  ///中间栏的项之间的间隔
  static const centerSectionItemGap = 8.0;
  static const windowSize = Size(960, 528);
  static const double titleBarHeight = 30.0;
  static const centerSectionToolBarHeight = 45.0;
  // 1024设备的目录宽度
  static const double lg1024DirectoryWidth = 300;
  // 1024设备的列表宽度
  static const double lg1024CenterSectionWidth = 300;
  static const double toolBarHeight = 50;

  /// developer options
  static const bool isDebug = false;
}
