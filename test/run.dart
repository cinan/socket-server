library server_tests;

import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';
import 'package:logging/logging.dart';
import 'package:messages/messages.dart';

import '../lib/manager.dart';

main() {
  bool verboseConsole = false;

  if (verboseConsole) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.loggerName} ${rec.level.name}: ${rec.time}: ${rec.message}');
    });
  }
}
