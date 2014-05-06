part of telephonist;

class WebSocketHandler extends Connection {

  WebSocket socket;

  WebSocketHandler(): super(null);

  void setStream(HttpRequest req) {
    StreamController sc = new StreamController();

    sc.stream.transform(new WebSocketTransformer())
             .listen(_handleInput);

    sc.add(req);
  }

  void add(data) {
    socket.add(data);
  }

  void addError(errorEvent, [StackTrace stackTrace]) {
    socket.addError(errorEvent, stackTrace);
  }

  Future addStream(Stream stream) {
    return socket.addStream(stream);
  }

  Future<bool> any(Function test) {
    return socket.any(test);
  }

  Stream<WebSocketHandler> asBroadcastStream({Function onListen, Function onCancel}) {
    return socket.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  Future close([int code, String reason]) {
    return socket.close(code, reason);
  }

  Future<bool> contains(Object needle) {
    return socket.contains(needle);
  }

  Stream<WebSocketHandler> distinct([Function equals]) {
    return socket.distinct(equals);
  }

  Future drain([futureValue]) {
    return socket.drain(futureValue);
  }

  Future<WebSocketHandler> elementAt(int index) {
    return socket.elementAt(index);
  }

  Future<bool> every(Function test) {
    return socket.every(test);
  }

  Stream expand(Function convert) {
    return socket.expand(convert);
  }

  Future<dynamic> firstWhere(Function test,  {Function defaultValue}) {
    return socket.firstWhere(test, defaultValue: defaultValue);
  }

  Future fold(initialValue, Function combine) {
    return socket.fold(initialValue, combine);
  }

  Future forEach(Function action) {
    return socket.forEach(action);
  }

  Stream<WebSocketHandler> handleError(Function onError,  {Function test}) {
    return socket.handleError(onError, test: test);
  }

  Future<String> join([String separator = ""]) {
    return socket.join(separator);
  }

  Future<dynamic> lastWhere(Function test,  {Function defaultValue}) {
    return socket.lastWhere(test, defaultValue: defaultValue);
  }

  StreamSubscription<WebSocketHandler> listen(Function onData, {Function onError, Function onDone, bool cancelOnError}) {
    return socket.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  Stream map(Function convert) {
    return socket.map(convert);
  }

  Future pipe(StreamConsumer<WebSocketHandler> streamConsumer) {
    return socket.pipe(streamConsumer);
  }

  Future<WebSocketHandler> reduce(Function combine) {
    return socket.reduce(combine);
  }

  Future<WebSocketHandler> singleWhere(Function test) {
    return socket.singleWhere(test);
  }

  Stream<WebSocketHandler> skip(int count) {
    return socket.skip(count);
  }

  Stream<WebSocketHandler> skipWhile(Function test) {
    return socket.skipWhile(test);
  }

  Stream<WebSocketHandler> take(int count) {
    return socket.take(count);
  }

  Stream<WebSocketHandler> takeWhile(Function test) {
    return socket.takeWhile(test);
  }

  Stream timeout(Duration timeLimit,  {Function onTimeout}) {
    return socket.timeout(timeLimit, onTimeout: onTimeout);
  }

  Future<List<WebSocketHandler>> toList() {
    return socket.toList();
  }

  Future<Set<WebSocketHandler>> toSet() {
    return socket.toSet();
  }

  Stream transform(StreamTransformer<WebSocketHandler, dynamic> streamTransformer) {
    return socket.transform(streamTransformer);
  }

  Stream<WebSocketHandler> where(Function test) {
    return socket.where(test);
  }

  int get closeCode => socket.closeCode;

  String get closeReason => socket.closeReason;

  Future get done => socket.done;

  String get extensions => socket.extensions;

  Future<WebSocketHandler> get first => socket.first;

  bool get isBroadcast => socket.isBroadcast;

  Future<bool> get isEmpty => socket.isEmpty;

  Future<WebSocketHandler> get last => socket.last;

  Future<int> get length => socket.length;

  String get protocol => socket.protocol;

  int get readyState => socket.readyState;

  Future<WebSocketHandler> get single => socket.single;

  Duration get pingInterval => socket.pingInterval;
  void set pingInterval(Duration interval) {
    socket.pingInterval = interval;
  }

  void _handleInput(WebSocket socket) {
    this.socket = socket;

    listen(onData, onError: onError, onDone: onClose, cancelOnError: cancelOnError);
  }
}