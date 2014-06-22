part of telephonist;

/**
 * TODO: rename
 */
class Messager {

  Logger _log = new Logger('Messager');

  Map _rawMessage;

  Transport _transport;

  int _nextSendId = 1;

  LinkedHashMap<dynamic, String> _messageBuffer = new LinkedHashMap<dynamic, String>();

  get message => (_rawMessage == null) ? null : _rawMessage['body'];

  Messager(this._transport, String message) {
    _rawMessage = decodeMessage(message);
    processMessage();
  }

  void send(data) {
    DataMessage message = new DataMessage(_nextSendId);
    message.body = data;

    _transport.send(message.toString());
  }

  void processMessage() {
    if (_isIncomingConfirmation()) {
      // TODO incoming confirmation?
    } else if (_isPing()) {
      _sendPong();
    } else {
      _sendConfirmation();
    }
  }

  Map decodeMessage(String message) {
    Map result = null;
    try {
      result = JSON.decode(message);
    } on FormatException {
      _log.warning('Malformatted message received');
      result = null;
    }

    return result;
  }

  void _sendConfirmation() {
    var id = _rawMessage['id'];

    if (id != null) {
      ConfirmationMessage message = new ConfirmationMessage(_nextSendId);
      message.confirmID = id;

      _transport.send(message.toString());
    }
  }

  void _sendPong() {
    PongMessage message = new PongMessage();
    _transport.send(message.toString());
  }

  bool _isIncomingConfirmation() {
    return ConfirmationMessage.matches(_rawMessage);
  }

  bool _isPing() {
    return PingMessage.matches(_rawMessage);
  }
}
