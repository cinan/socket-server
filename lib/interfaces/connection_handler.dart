part of telephonist;

abstract class ConnectionHandler {

  static const int CLOSED     = 0;
  static const int CLOSING    = 1;
  static const int CONNECTING = 2;
  static const int OPEN       = 3;

  static Future<ConnectionHandler> connect(String url, {List<String> protocols: []}) { }

  Function onData;

  Function onError;

  Function onClose;

  bool cancelOnError;

  Duration pingInterval;

  int get closeCode;

  String get closeReason;

  Future get done;

  String get extensions;

  Future<ConnectionHandler> get first;

  bool get isBroadcast;

  Future<bool> get isEmpty;

  Future<ConnectionHandler> get last;

  Future<int> get length;

  String get protocol;

  int get readyState;

  Future<ConnectionHandler> get single;

  void setStream(HttpRequest request);

  void add(data);

  void addError(errorEvent, [StackTrace stackTrace]);

  Future addStream(Stream stream);

  Future<bool> any(Function test);

  Stream<ConnectionHandler> asBroadcastStream({Function onListen, Function onCancel});

  Future close([int code, String reason]);

  Future<bool> contains(Object needle);

  Stream<ConnectionHandler> distinct([Function equals]);

  Future drain([futureValue]);

  Future<ConnectionHandler> elementAt(int index);

  Future<bool> every(Function test);

  Stream expand(Function convert);

  Future<dynamic> firstWhere(Function test, {Function defaultValue});

  Future fold(initialValue, Function combine);

  Future forEach(Function action);

  Stream<ConnectionHandler> handleError(Function onError, {Function test});

  Future<String> join([String separator = ""]);

  Future<dynamic> lastWhere(Function test, {Function defaultValue});

  StreamSubscription<ConnectionHandler> listen(Function onData, {Function onError, Function onDone, bool cancelOnError});

  Stream map(Function convert);

  Future pipe(StreamConsumer<ConnectionHandler> streamConsumer);

  Future<ConnectionHandler> reduce(Function combine);

  Future<ConnectionHandler> singleWhere(Function test);

  Stream<ConnectionHandler> skip(int count);

  Stream<ConnectionHandler> skipWhile(Function test);

  Stream<ConnectionHandler> take(int count);

  Stream<ConnectionHandler> takeWhile(Function test);

  Stream timeout(Duration timeLimit, {Function onTimeout});

  Future<List<ConnectionHandler>> toList();

  Future<Set<ConnectionHandler>> toSet();

  Stream transform(StreamTransformer<ConnectionHandler, dynamic> streamTransformer);

  Stream<ConnectionHandler> where(Function test);
}