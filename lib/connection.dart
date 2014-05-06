library telephonist;

import 'dart:io';
import 'dart:async';

part 'interfaces/connection_handler.dart';
part 'handlers/websocket_handler.dart';

class Connection implements ConnectionHandler {

  Function onData;
  Function onError;
  Function onClose;
  bool cancelOnError;

  ConnectionHandler handler;

  Connection(this.handler);

  void addToStream(HttpRequest request) {
    handler.setStream(request);
  }

  void setActions({Function onData, Function onError, Function onClose, bool cancelOnError: false}) {
    handler.onData        = onData;
    handler.onError       = onError;
    handler.onClose       = onClose;
    handler.cancelOnError = cancelOnError;
  }

  void add(data) {
    handler.add(data);
  }

  void addError(errorEvent, [StackTrace stackTrace]) {
    handler.addError(errorEvent, stackTrace);
  }

  Future addStream(Stream stream) {
    return handler.addStream(stream);
  }

  void setStream(HttpRequest request) {
    handler.setStream(request);
  }

  Future<bool> any(Function test) {
    return handler.any(test);
  }

  Stream<WebSocketHandler> asBroadcastStream({Function onListen, Function onCancel}) {
    return handler.asBroadcastStream(onListen: onListen, onCancel: onCancel);
  }

  Future close([int code, String reason]) {
    return handler.close(code, reason);
  }

  Future<bool> contains(Object needle) {
    return handler.contains(needle);
  }

  Stream<WebSocketHandler> distinct([Function equals]) {
    return handler.distinct(equals);
  }

  Future drain([futureValue]) {
    return handler.drain(futureValue);
  }

  Future<WebSocketHandler> elementAt(int index) {
    return handler.elementAt(index);
  }

  Future<bool> every(Function test) {
    return handler.every(test);
  }

  Stream expand(Function convert) {
    return handler.expand(convert);
  }

  Future<dynamic> firstWhere(Function test,  {Function defaultValue}) {
    return handler.firstWhere(test, defaultValue: defaultValue);
  }

  Future fold(initialValue, Function combine) {
    return handler.fold(initialValue, combine);
  }

  Future forEach(Function action) {
    return handler.forEach(action);
  }

  Stream<WebSocketHandler> handleError(Function onError,  {Function test}) {
    return handler.handleError(onError, test: test);
  }

  Future<String> join([String separator = ""]) {
    return handler.join(separator);
  }

  Future<dynamic> lastWhere(Function test,  {Function defaultValue}) {
    return handler.lastWhere(test, defaultValue: defaultValue);
  }

  StreamSubscription<WebSocketHandler> listen(Function onData, {Function onError, Function onDone, bool cancelOnError}) {
    return handler.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  Stream map(Function convert) {
    return handler.map(convert);
  }

  Future pipe(StreamConsumer<WebSocketHandler> streamConsumer) {
    return handler.pipe(streamConsumer);
  }

  Future<WebSocketHandler> reduce(Function combine) {
    return handler.reduce(combine);
  }

  Future<WebSocketHandler> singleWhere(Function test) {
    return handler.singleWhere(test);
  }

  Stream<WebSocketHandler> skip(int count) {
    return handler.skip(count);
  }

  Stream<WebSocketHandler> skipWhile(Function test) {
    return handler.skipWhile(test);
  }

  Stream<WebSocketHandler> take(int count) {
    return handler.take(count);
  }

  Stream<WebSocketHandler> takeWhile(Function test) {
    return handler.takeWhile(test);
  }

  Stream timeout(Duration timeLimit,  {Function onTimeout}) {
    return handler.timeout(timeLimit, onTimeout: onTimeout);
  }

  Future<List<WebSocketHandler>> toList() {
    return handler.toList();
  }

  Future<Set<WebSocketHandler>> toSet() {
    return handler.toSet();
  }

  Stream transform(StreamTransformer<WebSocketHandler, dynamic> streamTransformer) {
    return handler.transform(streamTransformer);
  }

  Stream<WebSocketHandler> where(Function test) {
    return handler.where(test);
  }

  int get closeCode => handler.closeCode;

  String get closeReason => handler.closeReason;

  Future get done => handler.done;

  String get extensions => handler.extensions;

  Future<WebSocketHandler> get first => handler.first;

  bool get isBroadcast => handler.isBroadcast;

  Future<bool> get isEmpty => handler.isEmpty;

  Future<WebSocketHandler> get last => handler.last;

  Future<int> get length => handler.length;

  String get protocol => handler.protocol;

  int get readyState => handler.readyState;

  Future<WebSocketHandler> get single => handler.single;

  Duration get pingInterval => handler.pingInterval;
  void set pingInterval(Duration interval) {
    handler.pingInterval = interval;
  }
}