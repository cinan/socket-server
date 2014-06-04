import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:server/telephonist_manager.dart';

final SERVER_HOST = InternetAddress.LOOPBACK_IP_V6.address;
final SERVER_PORT = 4040;

main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  Logger _log = new Logger('WebsocketTransport');

  runZoned(() {
    HttpServer.bind(SERVER_HOST, SERVER_PORT).then((HttpServer server) {
      TelephonistManager cm = new TelephonistManager(server);
      _log.fine("Listening on $SERVER_HOST:$SERVER_PORT");
    });
  }, onError: (e, stackTrace) {
    _log.shout("Something's gone wrong");
  });
}