import 'dart:ffi';
import 'dart:io';

import 'package:sqlite3/open.dart';

void overrideSqlite3() {
  if (Platform.isLinux) {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('/lib/x86_64-linux-gnu/libsqlite3.so.0'),
    );
  }
}
