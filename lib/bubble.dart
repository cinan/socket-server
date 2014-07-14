part of serverManager;

class Bubble {

  Logger _log = new Logger('Bubble');

  String _idClient;
  Manager _manager;

  List<Function> _messageTypes = [];

  StreamController<dynamic> _onMessageController = new StreamController<dynamic>();
  Stream<dynamic> get onMessage => _onMessageController.stream;

  StreamController<bool> _onCloseController = new StreamController<bool>();
  Stream<bool> get onClose => _onCloseController.stream;

  String get idClient => _idClient;

  void set manager(Manager manager) {
    _manager = manager;
  }

  void set messageTypes(List<Function> messageTypes) {
    _messageTypes = messageTypes;
  }

  Bubble(String this._idClient);

  void add(Message message) {
    if (acceptMessageType(message)) {
      _onMessageController.add(message.data);
    }
  }

  Future send(Message message) {
    if (_manager != null) {
      _manager.send(message, _idClient);
      return _manager.messageFuture(message.id);
    }

    return null;
  }

  bool acceptMessageType(Message unknownMessage) {
    String className = unknownMessage.runtimeType.toString();
    for (Message message in _messageTypes) {
      if (className == message.runtimeType.toString()) {
        return true;
      }
    }

    return false;
  }

  void close() {
    // TODO asi by som mal vracat idClienta?
    _onCloseController.add(true);
  }
}