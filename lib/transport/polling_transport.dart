  part of serverManager;

class PollingTransport implements Transport {

  Logger _log = new Logger('PollingTransport');

  Map<String, HttpRequest> _clientRequest = {};

  Map<String, bool> _clients = {};

  StreamController<Map> _onMessageController = new StreamController();
  Stream<Map>           get onMessage        => _onMessageController.stream;

  StreamController<String> _onOpenController = new StreamController();
  Stream<String> get onOpen => _onOpenController.stream;

  String _cookieName = 'sessionID';

  PollingTransport(Stream server, String url) {
    server.listen((HttpRequest request) {
      if (request.uri.path == url) {
        String idClient = _getIdClient(request);

        if (!_clients.containsKey(idClient)) {
          _onOpenController.add(idClient);
        }

        _clients[idClient] = true;

        HttpBodyHandler.processRequest(request).then((HttpRequestBody req) {
          if (_clientRequest[idClient] != null) {
            // request overlap
            req.request.response.statusCode = 500;
            req.request.response.close();
            _log.warning('request overlap');
          } else if (req.body is Map && req.body.containsKey('data')) {
            try {
              JsonObject data = new JsonObject.fromJsonString(req.body['data']);

              _clientRequest[idClient] = req.request;
              _onMessageController.add({
                  'idClient': idClient, 'data': data
              });
            } on FormatException { }
          }
        });
      }
    });
  }

  void send(String data, String idClient) {
    _log.fine('sending message');

    if (_clientRequest[idClient] != null) {
      HttpRequest req = _clientRequest[idClient];

      req.response.headers.add('Access-Control-Allow-Credentials', true);
      req.response.headers.add('Access-Control-Allow-Methods', 'POST');
      req.response.headers.add('Access-Control-Allow-Origin', req.headers.value('Origin'));

      req.response.cookies.add(new Cookie(_cookieName, idClient));

      req.response.write(data);
      req.response.close();

      _clientRequest[idClient] = null;
      _log.fine('message sent');
    }
  }

  void close(String idClient) {
    _clientRequest[idClient] = null;
    _clients.remove(idClient);
  }

  String _getIdClient(HttpRequest req) {
    Map<String, String> cookies = new Map.fromIterable(req.cookies,
      key: (Cookie cookie) => cookie.name, value: (Cookie item) => item.value);

    String idClient = (cookies.containsKey(_cookieName) && cookies[_cookieName].isNotEmpty)
      ? cookies[_cookieName]
      : new Uuid().v4();

    return idClient;
  }
}