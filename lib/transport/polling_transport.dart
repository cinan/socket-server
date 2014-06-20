part of telephonist;

class PollingTransport implements Transport {

  Logger _log = new Logger('PollingTransport');

  HttpRequest _request;

  StreamController _onMessageController = new StreamController();
  Stream           get onMessage        => _onMessageController.stream;

  PollingTransport(HttpRequest this._request) {
    _log.fine('Some message received');

    HttpBodyHandler.processRequest(_request).then((HttpRequestBody req) {
      var message = req.body['data'];
      _log.info('received: ${message}');
      Messager messager = new Messager(this, message);

      _onMessageController.add(messager.message);
    });
  }

  // TODO: vytvorit queue, do ktorej budem davat vsetky poziadavky a ktore odoslem naraz pri najblizsom spojeni s klientom
  //  , pricom quueue bude NAD transportami (kvoli vypadku spojenia...)
  // TODO: format prijimanych/odosielanych musi podorovat viacero sprav v jednej

  void send(data) {
    _log.fine('Sending response');

//    _request.response.headers.contentType = ContentType.JSON;
    _request.response.headers.add("Access-Control-Allow-Origin", "*");

    _request.response.write(data);
    _request.response.close();

    _log.info('sent ${data}');
  }
}