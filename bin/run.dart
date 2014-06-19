import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:server/telephonist_manager.dart';

main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  TelephonistManager cm = new TelephonistManager();
}