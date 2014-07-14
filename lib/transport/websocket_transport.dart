part of serverManager;

class WebsocketTransport implements Transport {

  Logger _log = new Logger('WebsocketTransport');

  Map<String, WebSocket> _clientToSocket = {};

  StreamController<String> _onOpenController = new StreamController();
  Stream<String> get onOpen => _onOpenController.stream;

  StreamController<Map> _onMessageController = new StreamController();
  Stream<Map> get onMessage => _onMessageController.stream;

  // TODO onDone?

  WebsocketTransport(Stream server, String url) {
    server.listen((HttpRequest request) {
      if (request.uri.path == url) {
        String idClient = _setupIdClient(request);
        request.response.headers.add("Access-Control-Allow-Origin", "*");

        WebSocketTransformer.upgrade(request).then((WebSocket socket) {
          _clientToSocket[idClient] = socket;

          _onOpenController.add(idClient);

          socket.listen((String rawMessage) {
            try {
              JsonObject data = new JsonObject.fromJsonString(rawMessage);
              _onMessageController.add({
                  'idClient': idClient, 'data': data
              });
            }
            on FormatException
            {
            }
          }, onError: (e) => _log.severe('Some error happened'), onDone: () {
            _clientToSocket.remove(idClient);
          }, cancelOnError: true);
        });
      }
    });
  }

  void send(String data, String idClient) {
    _log.fine('sending message');

    WebSocket socket = _clientToSocket[idClient];

    if (socket != null) {
      socket.add(data);
      _log.fine('message sent');
    }
  }

  String _setupIdClient(HttpRequest req) {
    String cookieName = 'sessionID';

    Map<String, String> cookies = new Map.fromIterable(req.cookies,
      key: (Cookie cookie) => cookie.name, value: (Cookie item) => item.value);

    String idClient = (cookies.containsKey(cookieName) && cookies[cookieName].isNotEmpty)
      ? cookies[cookieName]
      : new Uuid().v4();

    req.response.cookies.add(new Cookie(cookieName, idClient));

    return idClient;
  }
}