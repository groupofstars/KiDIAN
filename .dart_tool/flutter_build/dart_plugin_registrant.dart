//
// Generated file. Do not edit.
// This file is generated from template in file `flutter_tools/lib/src/flutter_plugins.dart`.
//

// @dart = 3.0

import 'dart:io'; // flutter_ignore: dart_io_import.
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';

@pragma('vm:entry-point')
class _PluginRegistrant {

  @pragma('vm:entry-point')
  static void register() {
    if (Platform.isAndroid) {
      try {
        SqflitePlugin.registerWith();
      } catch (err) {
        print(
          '`sqflite` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

    } else if (Platform.isIOS) {
      try {
        SqflitePlugin.registerWith();
      } catch (err) {
        print(
          '`sqflite` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

    } else if (Platform.isLinux) {
    } else if (Platform.isMacOS) {
      try {
        SqflitePlugin.registerWith();
      } catch (err) {
        print(
          '`sqflite` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
      }

    } else if (Platform.isWindows) {
    }
  }
}
