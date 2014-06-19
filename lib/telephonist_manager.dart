library telephonist;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';

import 'package:http_server/http_server.dart';
import 'package:logging/logging.dart';

part 'interface/transport.dart';
part 'transport/websocket_transport.dart';
part 'transport/polling_transport.dart';
part 'wrapper/messager.dart';

class TelephonistManager {

  final SERVER_HOST = InternetAddress.LOOPBACK_IP_V6.address;
  final SERVER_PORT = 4040;

  Logger _log = new Logger('TelephonistManager');

  TelephonistManager() {
    runZoned(() {
      HttpServer.bind(SERVER_HOST, SERVER_PORT).then((HttpServer server) {
        server.listen((HttpRequest request) {
          if (request.uri.path == '/ws') {
            new WebsocketTransport(request);
          } else if (request.uri.path == '/polling') {
            new PollingTransport(request);
          } else {
            throw new UnimplementedError();
          }
        });

        _log.fine("Listening on $SERVER_HOST:$SERVER_PORT");
      });
    }, onError: (e, stackTrace) {
      print(stackTrace);
      _log.shout("Something's gone wrong");
    });
  }
}