import 'dart:io';
import 'dart:async';
import 'connection.dart';

class TelephonistManager {

  HttpServer server;
  Connection connection;

  Map actions = {
      'onData':         null,
      'onError':        null,
      'onClose':        null,
      'cancelOnError':  false
  };

  TelephonistManager(this.server) {
    server.listen((HttpRequest request) {
      if (request.uri.path == '/ws') {
        connection = new Connection(new WebSocketHandler());
        connection.setActions( //TODO neda sa zapisat jednuduchsie?
            onData:         actions['onData'],
            onError:        actions['onError'],
            onClose:        actions['onClose'],
            cancelOnError:  actions['cancelOnError']
        );
        print ('connected');
        connection.addToStream(request);
      } else {
        throw new UnimplementedError();
      }
    });

//    new Timer(new Duration(seconds: 10), () {
//      exit(1);
//    });
  }
}