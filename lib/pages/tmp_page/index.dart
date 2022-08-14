import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:desktop_context_menu/desktop_context_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:flutter/services.dart';

class TmpPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const Tmp();
      },
    );
  }
}

class Tmp extends StatefulWidget {
  const Tmp({Key? key}) : super(key: key);

  @override
  State<Tmp> createState() => _TmpState();
}

class _TmpState extends State<Tmp> {
  bool _openContext = false;
  _showContext() async {
    final _menu = await showContextMenu(
      menuItems: [
        ContextMenuItem(
          title: '新建',
          onTap: () {},
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyN,
            meta: Platform.isMacOS,
            control: Platform.isWindows,
          ),
        ),
        const ContextMenuSeparator(),
        ContextMenuItem(
          title: '剪切',
          onTap: () {
            BotToast.showText(text: '你按了剪切');
          },
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyV,
            meta: Platform.isMacOS,
            control: Platform.isWindows,
          ),
        ),
        ContextMenuItem(
          title: '复制',
          onTap: () {
            BotToast.showText(text: '你按了复制');
          },
          shortcut: SingleActivator(
            LogicalKeyboardKey.keyC,
            meta: Platform.isMacOS,
            control: Platform.isWindows,
          ),
        ),
      ],
    );
    _menu?.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (e) {
          _openContext = e.kind == PointerDeviceKind.mouse && e.buttons == kSecondaryMouseButton;
          setState(() {});
        },
        onPointerUp: (e) {
          if (_openContext) {
            _showContext();
            _openContext = false;
          }
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hello'),
            ],
          ),
        ),
      ),
    );
  }
}
