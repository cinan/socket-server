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

  HttpServer _server;
  Transport _transport;

  TelephonistManager(this._server) {
    _server.listen((HttpRequest request) {
      if (request.uri.path == '/ws') {
        _transport = new WebsocketTransport(request);
      } else if (request.uri.path == '/polling') {
        _transport = new PollingTransport(request);
      } else {
        throw new UnimplementedError();
      }
    });
  }
}