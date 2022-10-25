import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revelation/service/device_service/index.dart';

import 'app/app.dart';
import 'config/config.dart';
import 'global_state/global_state_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setWindowSize(Config.windowSize);
    DeviceService.setDevice(DeviceType.windows);
  } else if (Platform.isAndroid || Platform.isIOS) {
    DeviceService.setDevice(DeviceType.phone);
  }

  Bloc.observer = GlobalStateObserver();
  runApp(const App());
}
