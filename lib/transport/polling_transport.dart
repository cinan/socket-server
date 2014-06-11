part of telephonist;

class PollingTransport implements Transport {

  Logger _log = new Logger('PollingTransport');

  HttpRequest _request;

  PollingTransport(HttpRequest this._request) {
    _log.fine('Some message received');

    HttpBodyHandler.processRequest(_request).then((HttpRequestBody req) {
      var message = req.body['data'];
      _log.info('received: ${message}');
      Messager messager = new Messager(this, message);
    });
  }

  void send(data) {
    _log.fine('Sending response');

//    _request.response.headers.contentType = ContentType.JSON;
    _request.response.headers.add("Access-Control-Allow-Origin", "*");

    _request.response.write(data);
    _request.response.close();

    _log.info('sent ${data}');
  }

//  void _setupListeners() {
//    },onError: (e) => _log.severe('Some error received'),
//      onDone: () => _log.finest('Stream done'),
//      cancelOnError: false
//    );
//  }
}