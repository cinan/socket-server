part of telephonist;

class WebsocketTransport implements Transport {

  Logger _log = new Logger('WebsocketTransport');

  int get readyState => (_socket == null) ? CLOSED : _socket.readyState;

  WebSocket _socket;

  WebsocketTransport(HttpRequest req) {
    setStream(req);
  }

  /**
   * Upgrades [req] to WebSocket connection.
   */
  void setStream(HttpRequest req) {
    StreamController sc = new StreamController();

    sc.stream.transform(new WebSocketTransformer())
             .listen((WebSocket socket) {
      _socket = socket;
      _setupListeners();
    });

    sc.add(req);
  }

  void send(data) {
    _socket.add(data);
  }

  void _setupListeners() {
    _socket.listen((String message) {
      _log.info('Some message received');
      Messager messager = new Messager(this, message);
      // TODO place for custom callbacks
    },onError: (e) => _log.severe('Some error received'),
      onDone: () => _log.finest('Stream done'),
      cancelOnError: false
    );
  }
}