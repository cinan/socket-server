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
part 'my_stream_consumer.dart';

class TelephonistManager {

  final SERVER_HOST = InternetAddress.LOOPBACK_IP_V6.address;
  final SERVER_PORT = 4040;

  Logger _log = new Logger('TelephonistManager');

  Transport _transport;

  StreamController _onMessageController = new StreamController();
  Stream           get onMessage        => _onMessageController.stream;

  TelephonistManager() {
//    runZoned(() {
      HttpServer.bind(SERVER_HOST, SERVER_PORT).then((HttpServer server) {
        server.listen((HttpRequest request) {
          if (request.uri.path == '/ws') {
            _transport = new WebsocketTransport(request);
          } else if (request.uri.path == '/polling') {
            _transport = new PollingTransport(request);
          } else {
            throw new UnimplementedError();
          }

          _setupListeners();
        });

        _log.fine("Listening on $SERVER_HOST:$SERVER_PORT");
      });
//    }, onError: (e, stackTrace) {
//      print(stackTrace);
//      _log.shout("Something's gone wrong");
//    });
  }

  /**
   * Alias for send() method
   */
  void respond(String message) {
    send(message);
  }

  void send(String message) {
    if (_transport != null) {
      // TODO: pridat do queue, ktora sa bude odosielat ku klientovi
      // TODO nejak inak poriesit zaobalovanie sprav do stringu
      _transport.send(message);
    }
  }

  void _setupListeners() {
    _transport.onMessage.pipe(new MyStreamConsumer(_onMessageController));
  }
}