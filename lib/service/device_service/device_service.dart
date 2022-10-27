import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

enum DeviceType { phone, windows }

class DeviceService {
  static Hook<DeviceType> deviceHook = Hook(DeviceType.windows);

  static setDevice(DeviceType value) => deviceHook.set(value);
}
